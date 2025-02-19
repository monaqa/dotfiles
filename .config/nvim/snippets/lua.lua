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

register("snippet_new")([==[
register("$1")([=[
$0
]=])
]==])

return snips
