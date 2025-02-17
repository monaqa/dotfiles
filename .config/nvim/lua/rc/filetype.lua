-- vim:fdm=marker:fmr=§§,■■
local monaqa = require("monaqa")

local link_filetype = monaqa.shorthand.link_filetype

-- §§1 ftdetect
link_filetype { pattern = "Satyristes", filetype = "lisp" }
link_filetype {
    extension = { "saty", "satyh", "satyh-*", "satyg" },
    filetype = function()
        if vim.fn.getline(1) == "%SATySFi v0.1.0" then
            return "satysfi_v0_1_0"
        else
            return "satysfi"
        end
    end,
}

link_filetype { extension = "fish", filetype = "fish" }
link_filetype { extension = "mmd", filetype = "mermaid" }
link_filetype { extension = "todome", filetype = "todome" }
link_filetype { extension = "nim", filetype = "nim" }
link_filetype { extension = "jison", filetype = "yacc" }
link_filetype { extension = "jsonl", filetype = "jsonl" }
link_filetype { extension = "d2", filetype = "d2" }
link_filetype { extension = "mdx", filetype = "markdown" }
link_filetype { extension = "nu", filetype = "nu" }
link_filetype { extension = "sus", filetype = "sus" }
link_filetype { extension = "mbt", filetype = "moonbit" }
link_filetype { extension = "plist", filetype = "xml" }

link_filetype { pattern = "LICENSE", filetype = "license" }
link_filetype { pattern = "*/queries/*/*.scm", filetype = "query" }
link_filetype { pattern = "uv.lock", filetype = "toml" }
