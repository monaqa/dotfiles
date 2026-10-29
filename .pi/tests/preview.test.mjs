import assert from "node:assert/strict";
import { request } from "node:http";
import test from "node:test";
import previewExtension from "../agent/extensions/preview/index.ts";
import { collectItems, renderPage } from "../agent/extensions/preview/render.ts";
import { startPreviewServer } from "../agent/extensions/preview/server.ts";

const message = (role, content, extra = {}) => ({ type: "message", message: { role, content, ...extra } });

test("conversation projection excludes internal roles and separates thinking/tools", () => {
  const items = collectItems([
    message("system", "system secret"),
    message("user", "# 日本語"),
    message("assistant", [
      { type: "thinking", thinking: "private reasoning" },
      { type: "text", text: "**本文**" },
      { type: "toolCall", name: "read", arguments: { path: "file" } },
    ]),
    message("toolResult", [{ type: "text", text: "tool output" }], { toolName: "read" }),
    message("assistant", [{ type: "toolCall", name: "bash", arguments: {} }]),
    message("assistant", [{ type: "thinking", thinking: "more reasoning" }]),
    message("custom", "custom secret"),
    { type: "compaction", summary: "summary secret" },
    message("user", [{ type: "image", data: "secret image bytes" }]),
  ]);
  assert.deepEqual(items.filter((item) => !item.technical).map((item) => item.text), ["# 日本語", "**本文**", "*[添付画像]*"]);
  assert.equal(items.filter((item) => item.technical).length, 5);
  assert.ok(!JSON.stringify(items).includes("secret"));
});

test("page escapes title and script payload and defaults to conversation only", () => {
  const text = '</script><script>alert("xss")</script> 日本語';
  const html = renderPage(text, [{ role: "user", text, technical: false }]);
  assert.ok(!html.includes(text));
  assert.ok(html.includes("&lt;/script&gt;"));
  const payload = html.match(/id="preview-data">(.*?)<\/script>/s)[1];
  assert.equal(JSON.parse(payload)[0].text, text);
  assert.ok(!html.includes('type="checkbox" checked'));
  assert.ok(renderPage("title", [], true).includes('type="checkbox" checked'));
});

function get(url, options = {}) {
  return new Promise((resolve, reject) => {
    request(url, options, (res) => {
      let body = "";
      res.setEncoding("utf8");
      res.on("data", (chunk) => { body += chunk; });
      res.on("end", () => resolve({ status: res.statusCode, headers: res.headers, body }));
    }).on("error", reject).end();
  });
}

test("server uses loopback, secret route, security headers, and closes cleanly", async (t) => {
  let server;
  try {
    server = await startPreviewServer({ marked: "parser", client: "client", style: "style" });
  } catch (error) {
    if (error.code !== "EPERM" || error.syscall !== "listen") throw error;
    t.skip("This sandbox does not permit localhost listeners");
    return;
  }
  try {
    assert.equal(new URL(server.url).hostname, "127.0.0.1");
    let snapshot = { title: "snapshot 1", items: [] };
    server.update(() => snapshot);
    const page = await get(server.url);
    assert.equal(page.status, 200);
    assert.match(page.body, /snapshot 1/);
    const snapshotUrl = new URL("snapshot.json", server.url);
    assert.deepEqual(JSON.parse((await get(snapshotUrl)).body), snapshot);
    assert.match(page.headers["content-security-policy"], /connect-src 'self'/);
    assert.equal(page.headers["cache-control"], "no-store");
    assert.equal(page.headers["referrer-policy"], "no-referrer");
    assert.match(page.headers["content-security-policy"], /frame-ancestors 'none'/);
    assert.equal((await get(new URL("marked.js", server.url))).body, "parser");
    assert.equal((await get(new URL("/", server.url))).status, 404);
    assert.equal((await get(new URL("../file", server.url))).status, 404);
    assert.equal((await get(server.url, { headers: { Host: "evil.example" } })).status, 403);
    assert.equal((await get(server.url, { method: "POST" })).status, 403);
    assert.equal((await get(server.url, { method: "HEAD" })).body, "");
    // Changes are visible without another update() or /preview call.
    snapshot = { title: "snapshot 2", items: [{ role: "assistant", text: "new answer", technical: false }] };
    assert.deepEqual(JSON.parse((await get(snapshotUrl)).body), snapshot);
    assert.match((await get(snapshotUrl)).headers["content-type"], /application\/json/);
    assert.equal((await get(snapshotUrl)).headers["cache-control"], "no-store");
    assert.match((await get(server.url)).body, /new answer/);
    assert.equal((await get(snapshotUrl, { headers: { Host: "evil.example" } })).status, 403);
    server.update(() => { throw new Error("unavailable session"); });
    assert.equal((await get(snapshotUrl)).status, 500);
  } finally {
    await server.close();
    await server.close();
  }
  await assert.rejects(get(server.url));
});

test("command follows getBranch without re-running preview, loads assets, and stops on shutdown", async (t) => {
  let command;
  let shutdown;
  let openedUrl;
  const notifications = [];
  previewExtension({
    registerCommand(name, definition) { assert.equal(name, "preview"); command = definition; },
    on(name, handler) { assert.equal(name, "session_shutdown"); shutdown = handler; },
    getSessionName() { return "Test session"; },
    async exec(_command, args) { openedUrl = args[0]; return { code: 0, killed: false, stderr: "" }; },
  });
  let branch = [message("user", "active branch only")];
  const ctx = {
    sessionManager: { getBranch: () => branch },
    ui: { notify: (...args) => notifications.push(args) },
  };
  try {
    await command.handler("", ctx);
    if (!openedUrl && notifications.some(([text]) => text.includes("listen EPERM"))) {
      t.skip("This sandbox does not permit localhost listeners");
      return;
    }
    assert.ok(openedUrl, JSON.stringify(notifications));
    assert.match((await get(openedUrl)).body, /active branch only/);
    assert.match((await get(new URL("marked.js", openedUrl))).body, /marked/i);
    const snapshotUrl = new URL("snapshot.json", openedUrl);
    branch.push(message("assistant", [{ type: "text", text: "continued answer" }]));
    assert.equal(JSON.parse((await get(snapshotUrl)).body).items.at(-1).text, "continued answer");
    // Branch navigation must not leak abandoned messages into the live page.
    branch = [message("user", "different branch")];
    assert.deepEqual(JSON.parse((await get(snapshotUrl)).body).items.map((item) => item.text), ["different branch"]);
    await command.handler("--all", ctx);
    assert.match((await get(openedUrl)).body, /type="checkbox" checked/);
    await command.handler("stop", ctx);
    await assert.rejects(get(openedUrl));
  } finally {
    await shutdown();
  }
});
