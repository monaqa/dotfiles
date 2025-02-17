local M = {}

function M.new_registerer(snips)
    return function(prefix)
        return function(body)
            snips[#snips + 1] = { prefix = prefix, body = body }
        end
    end
end

return M
