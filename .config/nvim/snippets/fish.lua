local snips = {}

local register = require("monaqa.snippet").new_registerer(snips)

register("function")([=[
function $1
    $0
end
]=])

return snips
