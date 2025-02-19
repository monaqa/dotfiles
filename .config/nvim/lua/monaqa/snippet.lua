local M = {}

function M.new_registerer(snips)
    return function(prefix)
        return function(body)
            snips[#snips + 1] = { prefix = prefix, body = body }
        end
    end
end

------@param filetype string
function M.edit_snippet_file(filetype)
    local fpath = vim.fn.stdpath("config") .. "/snippets/" .. filetype .. ".lua"
    vim.cmd.edit(fpath)
end

return M
