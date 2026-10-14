import { glob, stat } from "node:fs/promises";
import { homedir } from "node:os";
import { basename, dirname, join, relative } from "node:path";
import {
  SessionManager,
  getSelectListTheme,
  type ExtensionAPI,
  type SessionInfo,
} from "@earendil-works/pi-coding-agent";
import { Input, SelectList, truncateToWidth } from "@earendil-works/pi-tui";

const ROOT = join(homedir(), "Documents/typscrap-contents/content");

/** Discovery is read-only: never open/create a session while building the list. */
export async function discoverSessions(root: string): Promise<SessionInfo[]> {
  if (!(await stat(root)).isDirectory()) {
    throw new Error(`ディレクトリではありません: ${root}`);
  }
  const files = new Set<string>();
  const directories = new Set<string>();
  for await (const file of glob("**/sessions/*.jsonl", { cwd: root })) {
    const path = join(root, file);
    files.add(path);
    directories.add(dirname(path));
  }

  const sessions: SessionInfo[] = [];
  // Pi already bounds concurrency within each directory. Avoid starting an
  // unbounded number of directory scans (each scan reads transcript bodies).
  for (const directory of directories) {
    sessions.push(...(await SessionManager.listAll(directory)).filter((s) => files.has(s.path)));
  }
  return sessions.sort(
    (a, b) => b.modified.getTime() - a.modified.getTime() || a.path.localeCompare(b.path),
  );
}

// Session content is untrusted terminal text; strip control sequences before display.
export function singleLine(text: string): string {
  return text.replace(/\x1b\[[0-?]*[ -/]*[@-~]/g, "")
    .replace(/[\x00-\x1f\x7f-\x9f]/g, " ").replace(/\s+/g, " ").trim();
}

export function filterSessions(sessions: SessionInfo[], root: string, query: string): SessionInfo[] {
  const words = query.trim().toLocaleLowerCase().split(/\s+/).filter(Boolean);
  return sessions.filter((session) => {
    const text = singleLine(`${session.name ?? ""} ${session.firstMessage} ${relative(root, session.path)}`)
      .toLocaleLowerCase();
    return words.every((word) => text.includes(word));
  });
}

export default function(pi: ExtensionAPI) {
  pi.registerCommand("resume-scrap", {
    description: "Typscrap のセッションを検索して再開",
    handler: async (args, ctx) => {
      if (ctx.mode !== "tui") {
        ctx.ui.notify("/resume-scrap は TUI モードで使用してください", "error");
        return;
      }

      let sessions: SessionInfo[];
      try {
        sessions = await discoverSessions(ROOT);
      } catch (error) {
        ctx.ui.notify(`セッションを探索できません: ${String(error)}`, "error");
        return;
      }
      if (sessions.length === 0) {
        ctx.ui.notify("Typscrap に再開可能なセッションがありません", "info");
        return;
      }

      const currentPath = ctx.sessionManager.getSessionFile();
      const selected = await ctx.ui.custom<string | undefined>((tui, theme, kb, done) => {
        const input = new Input({ prompt: "検索: ", placeholder: "名前・最初のプロンプト・パス" });
        input.setValue(args.trim());
        let matches: SessionInfo[] = [];
        let list: SelectList;

        function updateList() {
          matches = filterSessions(sessions, ROOT, input.getValue());
          list = new SelectList(matches.map((session) => ({
            value: session.path,
            label: `${session.path === currentPath ? "● " : ""}${singleLine(session.name || session.firstMessage || basename(session.path))}`,
            description: `${session.modified.toLocaleString()} · ${session.messageCount} messages · ${singleLine(relative(ROOT, session.path))}`,
          })), 10, getSelectListTheme());
          list.onSelect = (item) => done(item.value);
          list.onCancel = () => done(undefined);
        }
        updateList();

        return {
          get focused() { return input.focused; },
          set focused(value: boolean) { input.focused = value; },
          invalidate() { input.invalidate(); list.invalidate(); },
          render(width: number) {
            const selectedSession = matches.find((s) => s.path === list.getSelectedItem()?.value);
            const lines = [
              theme.fg("accent", theme.bold(`Typscrap sessions (${matches.length}/${sessions.length})`)),
              ...input.render(width),
              "",
              ...(matches.length ? list.render(width) : [theme.fg("muted", "該当するセッションがありません")]),
              "",
            ];
            if (selectedSession) {
              lines.push(theme.fg("muted", singleLine(relative(ROOT, selectedSession.path))));
              lines.push(singleLine(selectedSession.firstMessage));
            }
            lines.push(theme.fg("muted", "↑↓ 選択 · Enter 再開 · Esc キャンセル · 検索語は空白区切りで AND"));
            return lines.map((line) => truncateToWidth(line, width));
          },
          handleInput(data: string) {
            if (kb.matches(data, "tui.select.cancel")) {
              done(undefined);
              return;
            }
            if ((["tui.select.up", "tui.select.down", "tui.select.pageUp", "tui.select.pageDown", "tui.select.confirm"] as const)
              .some((action) => kb.matches(data, action))) {
              list.handleInput(data);
            } else {
              const previous = input.getValue();
              input.handleInput(data);
              if (input.getValue() !== previous) updateList();
            }
            tui.requestRender();
          },
        };
      });

      if (!selected || selected === currentPath) return;
      // Do not accidentally recreate a file deleted while the picker was open.
      try {
        if (!(await stat(selected)).isFile()) throw new Error("通常ファイルではありません");
      } catch (error) {
        ctx.ui.notify(`セッションを開けません: ${String(error)}`, "error");
        return;
      }
      await ctx.waitForIdle();
      await ctx.switchSession(selected);
      // Session replacement invalidates ctx; do not use it after this point.
    },
  });
}
