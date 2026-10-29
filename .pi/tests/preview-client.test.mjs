import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { runInNewContext } from "node:vm";
import test from "node:test";

const source = await readFile(new URL("../agent/extensions/preview/client.js", import.meta.url), "utf8");
const item = (text) => ({ role: "assistant", text, technical: false });

// Minimal DOM/timer harness: exercise live-update behavior without a browser or
// a socket. Markdown parsing itself is intentionally stubbed, not tested here.
function browser(initialItems) {
  class Element {
    constructor(tagName = "div") {
      this.tagName = tagName.toUpperCase();
      this.nodeType = 1;
      this.children = [];
      this.textContent = "";
      this.events = {};
      if (tagName === "template") this.content = new Element("fragment");
    }
    get childNodes() { return this.children; }
    get lastElementChild() { return this.children.at(-1); }
    append(...nodes) { for (const node of nodes) { node.parent = this; this.children.push(node); } }
    replaceChildren() { this.children = []; }
    remove() { this.parent.children.splice(this.parent.children.indexOf(this), 1); }
    set innerHTML(text) { this.content.append({ nodeType: 3, textContent: text }); }
    setAttribute() {}
    addEventListener(event, handler) { this.events[event] = handler; }
  }
  const ids = Object.fromEntries(["messages", "preview-title", "preview-data", "live-status", "print", "show-details"].map((id) => [id, new Element()]));
  ids["preview-title"].textContent = "initial title";
  ids["preview-data"].textContent = JSON.stringify(initialItems);
  ids["show-details"].checked = true;
  const events = {};
  const document = {
    hidden: false,
    documentElement: { get scrollHeight() { return 1000 + ids.messages.children.length * 100; } },
    getElementById: (id) => ids[id],
    createElement: (tag) => new Element(tag),
    createTextNode: (text) => ({ nodeType: 3, textContent: text }),
    addEventListener: (name, handler) => { events[name] = handler; },
  };
  const scrolls = [];
  const window = {
    scrollX: 0, scrollY: 0, innerHeight: 500,
    scrollTo(x, y) { this.scrollX = x; this.scrollY = y; scrolls.push([x, y]); },
  };
  let nextSnapshot = { title: "initial title", items: initialItems };
  let fail = false;
  const requests = [];
  const timers = new Map();
  let timerId = 0;
  runInNewContext(source, {
    document, window, Node: { TEXT_NODE: 3, ELEMENT_NODE: 1 }, URL,
    marked: { parse: (text) => text },
    AbortSignal: { timeout: () => undefined },
    setTimeout: (handler) => { timers.set(++timerId, handler); return timerId; },
    clearTimeout: (id) => timers.delete(id),
    fetch: async (url, options) => {
      requests.push({ url, options });
      if (fail) throw new Error("offline");
      return { ok: true, json: async () => nextSnapshot };
    },
  });
  return {
    ids, document, window, scrolls, requests,
    snapshot(value) { nextSnapshot = value; },
    offline(value) { fail = value; },
    async tick() {
      assert.equal(timers.size, 1, "only one poll should be scheduled");
      const [id, handler] = timers.entries().next().value;
      timers.delete(id);
      await handler();
    },
    async visibility(hidden) {
      document.hidden = hidden;
      events.visibilitychange();
      await new Promise(setImmediate);
    },
  };
}

test("live polling appends without replacing old messages or resetting checkbox/scroll", async () => {
  const first = item("first");
  const b = browser([first]);
  const original = b.ids.messages.children[0];
  b.snapshot({ title: "new title", items: [first, item("second")] });
  await b.tick();
  assert.equal(b.ids.messages.children.length, 2);
  assert.equal(b.ids.messages.children[0], original);
  assert.equal(b.ids["show-details"].checked, true);
  assert.equal(b.ids["preview-title"].textContent, "new title");
  assert.equal(b.document.title, "new title · Pi preview");
  assert.deepEqual(b.scrolls, [[0, 0]], "reading old messages must not jump to bottom");
  assert.equal(b.requests[0].url, "./snapshot.json");
  assert.equal(b.requests[0].options.cache, "no-store");
  await b.tick();
  assert.equal(b.scrolls.length, 1, "unchanged snapshots should not touch scroll");
  assert.equal(b.ids.messages.children[0], original);
});

test("follows the bottom, replaces changed branches, and keeps last content on errors", async () => {
  const b = browser([item("old branch")]);
  b.window.scrollY = 600;
  b.snapshot({ title: "branch", items: [item("new branch"), item("answer")] });
  await b.tick();
  assert.deepEqual(b.scrolls.at(-1), [0, 1200]);
  const article = b.ids.messages.children[0];
  assert.equal(article.children[1].children[0].textContent, "new branch");
  b.offline(true);
  await b.tick();
  assert.equal(b.ids.messages.children[0], article);
  assert.match(b.ids["live-status"].textContent, /接続待ち/);
  b.offline(false);
  await b.tick();
  assert.match(b.ids["live-status"].textContent, /ライブ更新中/);
});

test("hidden tabs pause polling and refresh immediately when visible again", async () => {
  const b = browser([]);
  await b.visibility(true);
  assert.equal(b.requests.length, 0);
  b.snapshot({ title: "back", items: [item("while hidden")] });
  await b.visibility(false);
  assert.equal(b.requests.length, 1);
  assert.equal(b.ids.messages.children.length, 1);
  await b.tick();
  assert.equal(b.requests.length, 2);
});
