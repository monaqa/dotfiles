local register = require("monaqa.snippet").register

register("today") { [=[${TODAY:yyyy/mm/dd}]=] }

return register.snips
