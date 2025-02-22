local snips = {}

local register = require("monaqa.snippet").new_registerer(snips)

register("et")([=[
#table(stroke: none, columns: 2,
	..{
		let th(..args) = (table.header(..args.pos()),)
		let tr(..args) = (..args.pos(),)

		th[][]
		tr[][]
	},
	table.hline(y: 0), table.hline(y: 1, stroke: 0.5pt), table.hline(),
)
]=])

return snips
