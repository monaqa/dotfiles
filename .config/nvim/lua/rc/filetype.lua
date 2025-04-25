local function ftdetect_satysfi(path, bufnr)
    if vim.fn.getline(1) == "%SATySFi v0.1.0" then
        return "satysfi_v0_1_0"
    else
        return "satysfi"
    end
end

vim.filetype.add {
    extension = {
        d2 = "d2",
        fish = "fish",
        jison = "yacc",
        jsonl = "jsonl",
        mbt = "moonbit",
        mdx = "markdown",
        mmd = "mermaid",
        nim = "nim",
        nu = "nu",
        plist = "xml",
        sus = "sus",
        todome = "todome",
        saty = ftdetect_satysfi,
        satyh = ftdetect_satysfi,
        satyg = ftdetect_satysfi,
    },
    filename = {
        ["Satyristes"] = "lisp",
        ["LICENSE"] = "license",
        ["uv.lock"] = "toml",
    },
    pattern = {
        ["*/queries/*/*.scm"] = "query",
        ["*.satyh-*"] = ftdetect_satysfi,
    },
}
