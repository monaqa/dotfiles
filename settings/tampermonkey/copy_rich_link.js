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

  async function copyRichLink() {
    const t = document.title;
    const u = location.href;
    const h = `<a href="${u}">${t}</a>`;
    const p = `[${t}](${u})`;

    try {
      await navigator.clipboard.write([
        new ClipboardItem({
          "text/html": new Blob([h], { type: "text/html" }),
          "text/plain": new Blob([p], { type: "text/plain" }),
        }),
      ]);
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
      copyRichLink();
    }
  });
})();
