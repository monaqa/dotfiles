import { readFile } from "node:fs/promises";
import { join } from "node:path";
import { getPackageDir, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { collectItems } from "./render.ts";
import { startPreviewServer, type PreviewAssets } from "./server.ts";

async function loadAssets(): Promise<PreviewAssets> {
  // Reuse the Markdown parser bundled for Pi's /export; no CDN or extra install.
  // Pi's binary, npm, and source distributions have different asset locations.
  let marked: string | undefined;
  for (const directory of ["dist/core/export-html", "export-html", "src/core/export-html"]) {
    try {
      marked = await readFile(join(getPackageDir(), directory, "vendor/marked.min.js"), "utf8");
      break;
    } catch (error) {
      if ((error as NodeJS.ErrnoException).code !== "ENOENT") throw error;
    }
  }
  if (!marked) throw new Error("Pi に同梱された Markdown parser が見つかりません");
  return {
    marked,
    client: await readFile(new URL("./client.js", import.meta.url), "utf8"),
    style: await readFile(new URL("./style.css", import.meta.url), "utf8"),
  };
}

export default function (pi: ExtensionAPI) {
  let preview: Awaited<ReturnType<typeof startPreviewServer>> | undefined;
  const stop = async () => {
    const current = preview;
    preview = undefined;
    await current?.close();
  };
  pi.on("session_shutdown", stop);
  pi.registerCommand("preview", {
    description: "会話をブラウザで表示（本文のみ / --all: thinking・tools も表示 / stop: 終了）",
    handler: async (args, ctx) => {
      const option = args.trim();
      if (option === "stop") {
        await stop();
        ctx.ui.notify("プレビューサーバーを停止しました", "info");
        return;
      }
      if (option !== "" && option !== "--all") {
        ctx.ui.notify("使い方: /preview [--all | stop]", "error");
        return;
      }
      try {
        // Keep only the session manager, not the command context. Requests read
        // committed history, including messages completed after /preview.
        // session_shutdown closes the server before this session is replaced.
        const sessionManager = ctx.sessionManager;
        preview ??= await startPreviewServer(await loadAssets());
        preview.update(() => {
          const items = collectItems(sessionManager.getBranch());
          const title = pi.getSessionName() || items.find((item) => item.role === "user")?.text.slice(0, 80) || "Pi conversation";
          return { title, items };
        }, option === "--all");
        const command = process.platform === "darwin" ? "open" : process.platform === "win32" ? "explorer.exe" : "xdg-open";
        try {
          const result = await pi.exec(command, [preview.url], { timeout: 10_000 });
          if (result.code !== 0 || result.killed) throw new Error(result.stderr || "ブラウザを起動できません");
        } catch {
          ctx.ui.notify(`ブラウザを開けませんでした。手動で開いてください: ${preview.url}`, "warning");
          return;
        }
        ctx.ui.notify(`プレビュー: ${preview.url}`, "info");
      } catch (error) {
        ctx.ui.notify(`プレビューを作成できません: ${String(error)}`, "error");
      }
    },
  });
}
