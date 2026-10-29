import { randomBytes } from "node:crypto";
import { createServer } from "node:http";
import { renderPage, type PreviewSnapshot } from "./render.ts";

export interface PreviewAssets { marked: string; client: string; style: string }

/** Read the active conversation on demand. Never expose paths or bind to the LAN. */
export async function startPreviewServer(assets: PreviewAssets) {
  const token = randomBytes(24).toString("hex");
  const base = `/${token}/`;
  let getSnapshot: () => PreviewSnapshot = () => ({ title: "Pi conversation", items: [] });
  let showAll = false;
  const server = createServer((req, res) => {
    res.setHeader("Cache-Control", "no-store");
    res.setHeader("X-Content-Type-Options", "nosniff");
    res.setHeader("Referrer-Policy", "no-referrer");
    res.setHeader("Content-Security-Policy", "default-src 'none'; script-src 'self'; style-src 'self'; img-src 'none'; connect-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'");
    const address = server.address();
    const expectedHost = address && typeof address !== "string" ? `127.0.0.1:${address.port}` : "";
    // Host check also prevents DNS-rebinding access from unrelated websites.
    if (req.headers.host !== expectedHost || (req.method !== "GET" && req.method !== "HEAD")) {
      res.writeHead(403).end();
      return;
    }
    const routes: Record<string, [string, () => string]> = {
      [base]: ["text/html; charset=utf-8", () => {
        const snapshot = getSnapshot();
        return renderPage(snapshot.title, snapshot.items, showAll);
      }],
      [`${base}snapshot.json`]: ["application/json; charset=utf-8", () => JSON.stringify(getSnapshot())],
      [`${base}marked.js`]: ["text/javascript; charset=utf-8", () => assets.marked],
      [`${base}client.js`]: ["text/javascript; charset=utf-8", () => assets.client],
      [`${base}style.css`]: ["text/css; charset=utf-8", () => assets.style],
    };
    const resource = Object.hasOwn(routes, req.url ?? "") ? routes[req.url!] : undefined;
    if (!resource) { res.writeHead(404).end(); return; }
    try {
      const body = req.method === "HEAD" ? undefined : resource[1]();
      res.setHeader("Content-Type", resource[0]);
      res.writeHead(200).end(body);
    } catch {
      res.writeHead(500).end("Preview unavailable");
    }
  });
  await new Promise<void>((resolve, reject) => {
    server.once("error", reject);
    server.listen(0, "127.0.0.1", () => { server.off("error", reject); resolve(); });
  });
  server.unref();
  const address = server.address();
  if (!address || typeof address === "string") throw new Error("プレビューのポートを取得できません");
  return {
    url: `http://127.0.0.1:${address.port}${base}`,
    update(readSnapshot: () => PreviewSnapshot, all = false) {
      getSnapshot = readSnapshot;
      showAll = all;
    },
    close() {
      return new Promise<void>((resolve) => {
        server.close(() => resolve());
        server.closeAllConnections();
      });
    },
  };
}
