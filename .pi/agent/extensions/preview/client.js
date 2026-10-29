/* Markdown is untrusted. Rebuild an allowlisted DOM from an inert template;
 * never insert the parser's HTML into the live document. No external images,
 * event handlers, styles, arbitrary attributes, or active HTML are preserved. */
(() => {
  const allowed = new Set("P BR HR H1 H2 H3 H4 H5 H6 STRONG EM DEL BLOCKQUOTE PRE CODE UL OL LI TABLE THEAD TBODY TR TH TD A".split(" "));
  const dropped = new Set(["SCRIPT", "STYLE", "IFRAME", "OBJECT", "EMBED", "SVG", "MATH", "TEMPLATE"]);
  function copySafe(node, target) {
    if (node.nodeType === Node.TEXT_NODE) {
      target.append(document.createTextNode(node.textContent));
      return;
    }
    if (node.nodeType !== Node.ELEMENT_NODE || dropped.has(node.tagName)) return;
    if (node.tagName === "IMG") {
      target.append(document.createTextNode(`[画像: ${node.getAttribute("alt") || "image"}]`));
      return;
    }
    let output = target;
    if (allowed.has(node.tagName)) {
      output = document.createElement(node.tagName.toLowerCase());
      if (node.tagName === "A") {
        const href = node.getAttribute("href") || "";
        // Relative filesystem paths have no useful meaning in this reader.
        try {
          const url = new URL(href);
          if (["https:", "http:", "mailto:"].includes(url.protocol)) {
            output.setAttribute("href", url.href);
            output.setAttribute("target", "_blank");
            output.setAttribute("rel", "noopener noreferrer");
          }
        } catch { /* Leave unsupported links as text. */ }
      }
      target.append(output);
    }
    for (const child of node.childNodes) copySafe(child, output);
  }
  const messages = document.getElementById("messages");
  const title = document.getElementById("preview-title");
  const status = document.getElementById("live-status");
  let renderedItems = [];
  function renderItems(items) {
    // Keep unchanged messages in place (selection and code-block scroll survive
    // normal appends). A branch change replaces only the differing suffix.
    if (renderedItems.length === 0) messages.replaceChildren();
    let shared = 0;
    while (shared < items.length && shared < renderedItems.length &&
      JSON.stringify(items[shared]) === JSON.stringify(renderedItems[shared])) shared++;
    while (messages.children.length > shared) messages.lastElementChild.remove();
    for (const item of items.slice(shared)) {
      const article = document.createElement("article");
      article.className = `message ${item.technical ? "technical" : item.role === "user" ? "user" : "assistant"}`;
      const label = document.createElement("div");
      label.className = "role";
      label.textContent = item.role;
      const body = document.createElement("div");
      body.className = "markdown";
      if (item.technical) {
        const pre = document.createElement("pre");
        pre.textContent = item.text;
        body.append(pre);
      } else {
        const template = document.createElement("template");
        template.innerHTML = marked.parse(item.text, { gfm: true, breaks: false });
        for (const child of template.content.childNodes) copySafe(child, body);
      }
      article.append(label, body);
      messages.append(article);
    }
    if (items.length === 0) {
      const empty = document.createElement("p");
      empty.textContent = "表示する会話がありません。";
      messages.append(empty);
    }
    renderedItems = items;
  }
  const initial = { title: title.textContent, items: JSON.parse(document.getElementById("preview-data").textContent) };
  renderItems(initial.items);
  let previous = JSON.stringify(initial);
  let timer;
  let polling = false;
  async function poll() {
    if (polling) return;
    if (document.hidden) return; // visibilitychange restarts polling immediately.
    polling = true;
    try {
      const response = await fetch("./snapshot.json", { cache: "no-store", signal: AbortSignal.timeout(5000) });
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      const snapshot = await response.json();
      const serialized = JSON.stringify(snapshot);
      if (serialized !== previous) {
        const follow = window.scrollY + window.innerHeight >= document.documentElement.scrollHeight - 100;
        const { scrollX, scrollY } = window;
        title.textContent = snapshot.title;
        document.title = `${snapshot.title} · Pi preview`;
        renderItems(snapshot.items);
        previous = serialized;
        // Only follow if the reader was already at the bottom.
        window.scrollTo(scrollX, follow ? document.documentElement.scrollHeight : scrollY);
      }
      status.textContent = "ライブ更新中 · 確定したメッセージを自動反映";
    } catch {
      // Keep the last readable conversation if Pi stops or temporarily stalls.
      status.textContent = "接続待ち · Pi のプレビューサーバーへの再接続を試みています";
    } finally {
      polling = false;
      timer = setTimeout(poll, 1000);
    }
  }
  document.addEventListener("visibilitychange", () => {
    clearTimeout(timer);
    if (!document.hidden) void poll();
  });
  timer = setTimeout(poll, 1000);
  document.getElementById("print").addEventListener("click", () => window.print());
})();
