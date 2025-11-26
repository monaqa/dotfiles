local snips = {}

local register = require("monaqa.snippet").new_registerer(snips)

register("__main")([[
def main():
    """Main function.
    """
    $0

if __name__ == "__main__":
    main()
]])

register("todo")([=[
raise NotImplementedError("not implemented yet.")
]=])

return snips
