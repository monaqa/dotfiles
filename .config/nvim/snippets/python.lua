local register = require("monaqa.snippet").register

register("__main") { [=[
def main():
    """Main function.
    """
    $0

if __name__ == "__main__":
    main()
]=] }

register("todo") { [=[
raise NotImplementedError("not implemented yet.")
]=] }

return register.snips
