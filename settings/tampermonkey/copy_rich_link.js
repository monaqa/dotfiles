// ==UserScript==
// @name         Copy Rich Link (Title & URL)
// @namespace    http://tampermonkey.net/
// @version      1.1
// @description  現在のページのタイトルとURLをリッチテキスト形式でコピーします (Ctrl+Y)
// @author       monaqa
// @match        *://*/*
// @grant        GM_registerMenuCommand
// ==/UserScript==

(function () {
  "use strict";

  async function copyRichLink(markdown) {
    const t = document.title;
    const u = location.href;

    const item = markdown
      ? ({
        "text/html": new Blob([`<a href="${u}">${t}</a>`], {
          type: "text/html",
        }),
        "text/plain": new Blob([`[${t}](${u})`], { type: "text/plain" }),
      })
      : ({
        "text/plain": new Blob([u], { type: "text/plain" }),
      });

    try {
      await navigator.clipboard.write([new ClipboardItem(item)]);
    } catch (e) {
      console.error("Copy failed:", e);
      alert("コピーに失敗しました。");
    }
  }

  // メニューコマンド
  GM_registerMenuCommand("Copy Rich Link", copyRichLink);

  // ショートカットキー: Ctrl + Y
  document.addEventListener("keydown", (e) => {
    if (e.ctrlKey && (e.key === "y" || e.key === "Y")) {
      e.preventDefault(); // ブラウザのデフォルト動作（やり直し等）をキャンセル
      copyRichLink(true);
    }
  });

  document.addEventListener("keydown", (e) => {
    if (
      e.metaKey && e.shiftKey && !e.ctrlKey && !e.altKey &&
      (e.key === "c" || e.key === "C")
    ) {
      e.preventDefault(); // ブラウザのデフォルト動作（やり直し等）をキャンセル
      copyRichLink(false);
    }
  });
})();
