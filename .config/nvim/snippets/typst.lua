local snips = {}

local register = require("monaqa.snippet").new_registerer(snips)

register("today")([=[${TODAY:yyyy/mm/dd}]=])

register("et")([=[
#table(stroke: none,
  ..{
    let hl(..args) = arguments(table.hline(..args),)
    let th(..args) = {
      arguments(table.header(..args.pos()))
      arguments(columns: args.pos().len())
      hl(stroke: 0.5pt)
    }
    let tr(..args) = arguments(..args.pos(),)

    hl()
    th[][]
    tr[][]
    hl()
  },
)
]=])

register("showybox")([=[
#showybox(
	title: [${1:Title}],
	frame: (border-color: luma(25%), title-color: luma(80%), body-color: luma(95%)),
	title-style: (color: luma(25%), weight: 600, align: center),
)[
	$0
]
]=])

register("cetz")([=[
#import "@preview/cetz:0.3.2"

#cetz.canvas(length: 20pt, {
	import cetz.draw: *

	grid((0, 0), (10, 10), stroke: luma(85%) + 0.25pt, step: 0.25)
	grid((0, 0), (10, 10), stroke: luma(70%) + 0.5pt)

	circle((2, 2), radius: 1)
	rect((1, 1), (3, 2), stroke: red)
	content((2, 2), anchor: "south", padding: 0.1)[test]
	$0
})
]=])

return snips
