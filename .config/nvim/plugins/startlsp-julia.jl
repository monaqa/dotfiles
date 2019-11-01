using LanguageServer;
using Pkg;
import StaticLint;
import SymbolServer;

env_path = dirname(Pkg.Types.Context().env.project_file);
debug = true;
server = LanguageServer.LanguageServerInstance(stdin, stdout, debug, env_path, "", Dict());
server.runlinter = true;
run(server);
