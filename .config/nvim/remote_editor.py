# /// script
# requires-python = ">=3.13"
# dependencies = []
# ///

import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


def lua_string(value: str) -> str:
    """UTF-8 の各バイトを Lua の10進エスケープで表現する。"""
    return '"' + "".join(f"\\{byte:03d}" for byte in value.encode("utf-8")) + '"'


def main() -> int:
    args = sys.argv[1:]
    nvr = shutil.which("nvr")
    if not os.environ.get("NVIM") or nvr is None:
        os.execvp("nvim", ["nvim", *args])

    with tempfile.TemporaryDirectory(prefix="nvim-editor-") as directory:
        status_file = Path(directory) / "status"
        status_file.write_text("", encoding="utf-8")

        result = subprocess.run(
            [
                nvr,
                "-cc",
                'lua require("rc.remote_editor").before()',
                "-c",
                f'lua require("rc.remote_editor").attach({lua_string(str(status_file))})',
                "--remote-wait",
                *args,
            ],
            check=False,
        )
        if result.returncode != 0:
            return 1

        # 保存時のみ Lua 側が "ok\n" を書く。キャンセル時は空のまま。
        saved = status_file.read_text(encoding="utf-8").rstrip("\n") == "ok"
        return 0 if saved else 1


if __name__ == "__main__":
    try:
        sys.exit(main())
    except OSError as error:
        print(f"remote editor: {error}", file=sys.stderr)
        sys.exit(1)
