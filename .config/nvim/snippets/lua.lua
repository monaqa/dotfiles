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
register("nmap")([=[
mapset.n("$1") { "$0" }
]=])
register("inoremap")([=[
mapset.i("$1") {
    desc = [[]],
    function ()
        $0
    end,
}
]=])
register("imap")([=[
mapset.i("$1") { "$0" }
]=])
register("cnoremap")([=[
mapset.c("$1") {
    desc = [[]],
    function ()
        $0
    end,
}
]=])
register("cmap")([=[
mapset.c("$1") { "$0" }
]=])
register("xnoremap")([=[
mapset.x("$1") {
    desc = [[]],
    funxtion ()
        $0
    end,
}
]=])
register("xmap")([=[
mapset.x("$1") { "$0" }
]=])
register("onoremap")([=[
mapset.o("$1") {
    desc = [[]],
    funotion ()
        $0
    end,
}
]=])
register("omap")([=[
mapset.o("$1") { "$0" }
]=])
register("noremap")([=[
mapset.nxo("$1") {
    desc = [[]],
    function ()
        $0
    end,
}
]=])
register("map")([=[
mapset.nxo("$1") { "$0" }
]=])

register("snippet_new")([==[
register("$1")([=[
$0
]=])
]==])

return snips
