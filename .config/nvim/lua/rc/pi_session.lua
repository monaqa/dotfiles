local M = {}
local monaqa = require("monaqa")
local tree = monaqa.tree

local pi_terminal_bufid = nil
local pi_session_buffers = {}

local function pi_terminal_alive(buf)
    return buf and vim.api.nvim_buf_is_valid(buf)
        and vim.bo[buf].buftype == "terminal"
        and vim.fn.jobwait({ vim.b[buf].terminal_job_id }, 0)[1] == -1
end

function M.has_pi_terminal()
    return not not pi_terminal_alive(pi_terminal_bufid)
end

function M.get_command()
    if M.path_at_cursor() then
        return "PiSessionOpen"
    end
    local session_id = M.session_id_at_cursor()
    if session_id then
        return "Pi --session " .. session_id
    end
    return M.has_pi_terminal() and "Pi" or "Pi -c"
end

local function map_pi_keys(buf)
    local mapset = monaqa.shorthand.mapset_local

    local function send(key)
        return function()
            vim.api.nvim_chan_send(vim.b[buf].terminal_job_id, vim.keycode(key))
        end
    end

    local function paragraph(step)
        local line = vim.fn.line(".")
        local last = vim.api.nvim_buf_line_count(buf)
        local remaining = vim.v.count1
        local chunk, first, final = {}, 0, -1
        local function is_blank(lnum)
            if lnum < first or lnum > final then
                first = math.max(1, lnum - (step < 0 and 127 or 0))
                final = math.min(last, first + 127)
                chunk = vim.api.nvim_buf_get_lines(buf, first - 1, final, false)
            end
            return chunk[lnum - first + 1]:match("^%s*$") ~= nil
        end

        local in_blank = is_blank(line)
        local target = step > 0 and last or 1
        for lnum = line + step, target, step do
            if is_blank(lnum) then
                if not in_blank then
                    remaining = remaining - 1
                    if remaining == 0 then
                        target = lnum
                        break
                    end
                    in_blank = true
                end
            else
                in_blank = false
            end
        end
        vim.cmd.normal {
            args = { tostring(target) .. "G" },
            bang = true,
        }
    end

    mapset.nxo("<C-j>") {
        desc = [[Pi: paragraph motion (down)]],
        function() paragraph(1) end,
    }
    mapset.nxo("<C-k>") {
        desc = [[Pi: paragraph motion (up)]],
        function() paragraph(-1) end,
    }

    mapset.n("<CR>") {
        desc = [[Pi: submit (Ctrl + Enter)]],
        function()
            vim.api.nvim_chan_send(vim.b[buf].terminal_job_id, "\27[13;5u")
        end,
    }

    mapset.n("Z") { send("<C-o>"), desc = [[Pi: toggle collapsing]] }
    mapset.n("o") { [[i<C-g>]], desc = [[Pi: open prompt buffer in neovim]] }
    mapset.t("<Esc>") { [[<C-\><C-n>]], desc = [[Pi: back to NORMAL mode]] }
end

function M.open(meta)
    local reuse = meta.args == "" and pi_terminal_alive(pi_terminal_bufid)
    if not reuse and not monaqa.logic.to_bool(vim.fn.executable("fish")) then
        vim.notify("fish が見つかりません", vim.log.levels.ERROR)
        return
    end

    if reuse then
        local win = vim.fn.bufwinid(pi_terminal_bufid)
        if win ~= -1 then
            vim.api.nvim_set_current_win(win)
            return
        end
    end

    monaqa.window.wise_split()
    if reuse then
        vim.cmd.buffer { pi_terminal_bufid }
    else
        vim.cmd.enew()
        vim.fn.jobstart(
            { "fish", "-c", "exec pi" .. (meta.args == "" and "" or " " .. meta.args) },
            { term = true }
        )
        pi_terminal_bufid = vim.api.nvim_get_current_buf()
        vim.b[pi_terminal_bufid].pi_terminal = true
        map_pi_keys(pi_terminal_bufid)
    end
end

function M.path_at_cursor()
    local note = vim.api.nvim_buf_get_name(0)
    if note == "" then
        return nil
    end

    local captures = tree.match_at_cursor("typst", [[
        (
         (call item: (ident) @session_cmd
          (group (call item: (ident) @path_cmd
           (group (string) @path)
          ))
         ) @cursor
         (#eq? @session_cmd "session")
         (#eq? @path_cmd "path")
        )
    ]], "cursor")

    if not captures then
        return nil
    end

    local ok, path = pcall(vim.json.decode, vim.treesitter.get_node_text(captures.path, 0))
    if ok and type(path) == "string" and path ~= "" and not vim.startswith(path, "/") then
        return vim.fs.normalize(vim.fs.joinpath(vim.fs.dirname(note), path))
    end
end

function M.session_id_at_cursor()
    local captures = tree.match_at_cursor("typst", [[
        (
         (call item: (ident) @session_cmd
          (group (string) @session_id)
         ) @cursor
         (#eq? @session_cmd "session")
        )
    ]], "cursor")

    if not captures then
        return
    end

    local ok, session_id = pcall(vim.json.decode, vim.treesitter.get_node_text(captures.session_id, 0))
    if not ok or type(session_id) ~= "string" then
        return
    end
    return session_id
end

function M.open_at_cursor()
    local path = require("rc.pi_session").path_at_cursor()
    if not path then
        vim.notify("カーソル下に有効なセッションが存在しません", vim.log.levels.ERROR)
        return
    end
    local buf = pi_session_buffers[path]
    if pi_terminal_alive(buf) then
        local win = vim.fn.bufwinid(buf)
        if win ~= -1 then
            vim.api.nvim_set_current_win(win)
            return
        end
    else
        buf = nil
        pi_session_buffers[path] = nil
    end

    if not buf and not vim.uv.fs_stat(path) then
        vim.fn.mkdir(vim.fs.dirname(path), "p")
        local file, err = io.open(path, "w")
        if file then
            file:close()
        elseif not vim.uv.fs_stat(path) then
            vim.notify("セッションファイルを作成できません", vim.log.levels.ERROR)
            return
        end
    end

    monaqa.window.wise_split()
    if buf then
        vim.cmd.buffer { buf }
        return
    end

    vim.cmd.enew()
    local job = vim.fn.jobstart({ "pi", "--session", path }, { term = true })
    if job <= 0 then
        vim.notify("Pi の起動に失敗しました", vim.log.levels.ERROR)
        return
    end

    buf = vim.api.nvim_get_current_buf()
    pi_session_buffers[path] = buf
    vim.b[buf].pi_terminal = true
    map_pi_keys(buf)
end

return M
