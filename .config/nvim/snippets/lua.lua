local snips = {}

local register = require("monaqa.snippet").new_registerer(snips)

register("nnoremap")([=[
mapset.n("$1") {
    desc = [[]],
    function ()
        $0
    end,
}
]=])

return snips
