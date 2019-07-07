import LanguageServer
import Pkg
import SymbolServer

envpath = dirname(Pkg.Types.Context().env.project_file)

const DEPOT_DIR_NAME = ".julia"
depotpath = if Sys.iswindows()
    joinpath(ENV["USERPROFILE"], DEPOT_DIR_NAME)
else
    joinpath(ENV["HOME"], DEPOT_DIR_NAME)
end

server = LanguageServer.LanguageServerInstance(stdin, stdout, false, envpath, depotpath, Dict())
server.runlinter = true
run(server)
