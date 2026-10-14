import assert from "node:assert/strict";
import { randomUUID } from "node:crypto";
import { mkdtemp, mkdir, readFile, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import test from "node:test";
import { discoverSessions, filterSessions, singleLine } from "../agent/extensions/resume-scrap.ts";

async function fixture(path, prompt, timestamp, name) {
  await mkdir(join(path, ".."), { recursive: true });
  const entries = [
    { type: "session", version: 3, id: randomUUID(), timestamp, cwd: tmpdir() },
    { type: "message", id: "abc12345", parentId: null, timestamp,
      message: { role: "user", content: [{ type: "text", text: prompt }], timestamp: Date.parse(timestamp) } },
  ];
  if (name) entries.push({ type: "session_info", id: "def12345", parentId: "abc12345", timestamp, name });
  await writeFile(path, entries.map((e) => JSON.stringify(e)).join("\n") + "\n");
}

test("discover nested sessions, ignore empty/invalid/nonmatching files, and preserve originals", async () => {
  const root = await mkdtemp(join(tmpdir(), "resume-scrap-"));
  try {
    const older = join(root, "notes", "sessions", "older.jsonl");
    const newer = join(root, "deep", "日本語", "sessions", "newer.jsonl");
    await fixture(older, "Fix Lua config", "2026-01-01T00:00:00Z");
    await fixture(newer, "Typst の実装\n続き", "2026-02-01T00:00:00Z", "日本語テスト");
    await fixture(join(root, "other", "ignored.jsonl"), "ignored", "2026-03-01T00:00:00Z");
    await writeFile(join(root, "notes", "sessions", "empty.jsonl"), "");
    await writeFile(join(root, "notes", "sessions", "invalid.jsonl"), "not json\n");
    const before = await readFile(newer, "utf8");
    const sessions = await discoverSessions(root);
    assert.deepEqual(sessions.map((s) => s.path), [newer, older]);
    assert.equal(sessions[0].name, "日本語テスト");
    assert.equal(sessions[0].firstMessage, "Typst の実装\n続き");
    assert.equal(sessions[0].messageCount, 1);
    assert.deepEqual(filterSessions(sessions, root, "TYPST 日本語"), [sessions[0]]);
    assert.deepEqual(filterSessions(sessions, root, "notes Lua"), [sessions[1]]);
    assert.deepEqual(filterSessions(sessions, root, "missing"), []);
    assert.equal(filterSessions(sessions, root, "  ").length, 2);
    assert.equal(await readFile(newer, "utf8"), before);
    await assert.rejects(discoverSessions(join(root, "missing")));
  } finally {
    await rm(root, { recursive: true, force: true });
  }
});

test("display strings are single-line and stripped of control codes", () => {
  assert.equal(singleLine("\x1b[31m日本語\x1b[0m\n\ttext\x00"), "日本語 text");
});
