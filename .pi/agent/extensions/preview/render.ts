import type { SessionEntry } from "@earendil-works/pi-coding-agent";

export interface PreviewItem {
  role: string;
  text: string;
  technical: boolean;
}

export interface PreviewSnapshot {
  title: string;
  items: PreviewItem[];
}

/** Use the active branch, not model context (which loses pre-compaction history). */
export function collectItems(entries: readonly SessionEntry[]): PreviewItem[] {
  const items: PreviewItem[] = [];
  for (const entry of entries) {
    if (entry.type !== "message") continue;
    const message = entry.message;
    if (message.role !== "user" && message.role !== "assistant" && message.role !== "toolResult") continue;
    const technical = message.role === "toolResult";
    const role = technical ? `tool: ${message.toolName}` : message.role;
    const content = message.content;
    if (typeof content === "string") {
      if (content.trim()) items.push({ role, text: content, technical });
      continue;
    }
    // Keep block order, but group adjacent text blocks into a single message.
    let text: string[] = [];
    const flush = () => {
      if (text.join("\n\n").trim()) items.push({ role, text: text.join("\n\n"), technical });
      text = [];
    };
    for (const block of content) {
      if (block.type === "text") {
        text.push(block.text);
      } else if (block.type === "image") {
        text.push("*[添付画像]*");
      } else if (block.type === "thinking") {
        flush();
        if (block.thinking.trim()) items.push({ role: "thinking", text: block.thinking, technical: true });
      } else if (block.type === "toolCall") {
        flush();
        items.push({ role: `call: ${block.name}`, text: JSON.stringify(block.arguments, null, 2), technical: true });
      }
    }
    flush();
  }
  return items;
}

export function escapeHtml(text: string): string {
  return text.replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[c]!);
}

export function renderPage(title: string, items: PreviewItem[], all = false): string {
  // JSON in an inert script must not be able to terminate its script element.
  const data = JSON.stringify(items).replace(/</g, "\\u003c");
  return `<!doctype html>
<html lang="ja"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>${escapeHtml(title)} · Pi preview</title><link rel="stylesheet" href="./style.css">
<script defer src="./marked.js"></script><script defer src="./client.js"></script></head>
<body><header><div class="toolbar"><a class="brand" href="#">π <span>PREVIEW</span></a>
<label><input id="show-details" type="checkbox" ${all ? "checked" : ""}> thinking / tools を表示</label>
<button type="button" id="print">印刷 / PDF</button></div></header>
<main><div class="intro"><p class="eyebrow">LOCAL CONVERSATION READER</p><h1 id="preview-title">${escapeHtml(title)}</h1>
<p id="live-status" role="status">ライブ更新 · 現在のブランチを自動更新します</p></div>
<div id="messages"></div><noscript>Markdown の表示には JavaScript を有効にしてください。</noscript>
<footer>Pi · localhost only · 外部画像は読み込みません</footer></main>
<script type="application/json" id="preview-data">${data}</script></body></html>`;
}
