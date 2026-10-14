local M = {}
local tree = require("monaqa.tree")

function M.path_at_cursor()
    local note = vim.api.nvim_buf_get_name(0)
    if note == "" then
        return nil
    end

    -- local captures = tree.match_at_cursor("typst", [[
    --     (
    --      (code
    --       (call
    --        item: (ident) @name
    --        (group (string) @path)
    --       )
    --      ) @cursor
    --      (#eq? @name "session")
    --     )
    -- ]], "cursor")
    local captures = tree.match_at_cursor("typst", [[
        (
         (call item: (ident) @session_cmd
          (group (call item: (ident) @path_cmd
           (group (string) @path)
          ))
         ) @cursor
         (#eq? @session_cmd "session")
         (#eq? @path_cmd "path")
        )
    ]], "cursor")

    if not captures then
        return nil
    end

    local ok, path = pcall(vim.json.decode, vim.treesitter.get_node_text(captures.path, 0))
    if ok and type(path) == "string" and path ~= "" and not vim.startswith(path, "/") then
        return vim.fs.normalize(vim.fs.joinpath(vim.fs.dirname(note), path))
    end
end

return M
