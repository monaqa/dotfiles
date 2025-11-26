local register = require("monaqa.snippet").register

register("function") { [=[
function $1
    $0
end
]=] }

return register.snips
