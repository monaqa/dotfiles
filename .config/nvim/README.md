# Neovim の設定方針

## ディレクトリ構成

設定用 Lua ファイルは `init.lua` を除き、以下のパスに格納する。

- `lua/monaqa`: 設定用の関数定義。

    - 基本的に以下のいずれかの形式で呼び出して使う想定。
        - `local monaqa = reqiure("monaqa")`
        - `local xxx = reqiure("monaqa.xxx")`
    - require しただけでは副作用が発生しない。

- `lua/rc`: run commands に相当する設定を書く。

    - `reqiure("rc.*")` と書くだけで色々実行される。
    - `init.lua` の分割用。
    - lazy のセットアップ用。

- `lua/rc/plugins`: プラグイン用の設定。
    - 例外的に、このあたりのモジュールは基本的に副作用が発生しない。

このように分けることで、設定時に使いやすい函数の抽象化などをどんどん進める。

```
 .
├──  init.lua
├──  lua
│   └──  rc
│       ├──  plugins
│       ├──  util
│       ├──  abbr.lua
│       ├──  autocmd.lua
│       ├──  clipboard.lua
│       ├──  command.lua
│       ├──  diary.lua
│       ├──  filetype.lua
│       ├──  keymap.lua
│       ├──  obsidian.lua
│       ├──  opfunc.lua
│       ├──  option.lua
│       ├──  plugins.lua
│       ├──  submode.lua
│       ├──  types.lua
│       └──  util.lua
├──  after
│   ├──  ftplugin
│   └──  queries
├──  queries
├──  resource
├──  syntax
├──  coc-settings.json
└──  lazy-lock.json
```


## 
