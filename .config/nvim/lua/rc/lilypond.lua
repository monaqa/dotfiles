-- Lilypond 関連の便利関数。

local lpeg = vim.lpeg
local S = lpeg.S
local P = lpeg.P
local C = lpeg.C

---@param key string
---@return string, string, string
local function parse_key(key)
    local pat_pitch = S("cdefgab")
    local pat_acc = P("isis") + P("eses") + P("is") + P("es")
    local pat_tonality = P([[\major]]) + P([[\minor]])
    local pattern = C(pat_pitch) * C(pat_acc ^ 0 ^ -1) * C(pat_tonality)
    return pattern:match(key)
end

---@param note string
---@return string, string, string
local function parse_note(note)
    local pat_pitch = S("cdefgab")
    local pat_acc = P("isis") + P("eses") + P("is") + P("es")
    local pat_octave = P(",") ^ 1 ^ -2 + P("'") ^ 1 ^ -2
    local pattern = C(pat_pitch) * C(pat_acc ^ 0 ^ -1) * C(pat_octave ^ 0 ^ -1)
    return pattern:match(note)
end

local M = {}

-- (tonal center, pitch) → 使うべき pitch 音の辞書
local tone_table = {
    { 0, nil, 2, nil, 4, 5, nil, 7, nil, 9, nil, 11 },
    { 0, 2, nil, 4, nil, 5, 7, nil, 9, nil, 11, nil },
    { nil, 0, 2, nil, 4, nil, 5, 7, nil, 9, nil, 11 },
    { 0, nil, 2, 4, nil, 5, nil, 7, 9, nil, 11, nil },
    { nil, 0, nil, 2, 4, nil, 5, nil, 7, 9, nil, 11 },
    { 0, nil, 2, nil, 4, 5, nil, 7, nil, 9, 11, nil },
    { nil, 0, nil, 2, nil, 4, 5, nil, 7, nil, 9, 11 },
    { 0, nil, 2, nil, 4, nil, 5, 7, nil, 9, nil, 11 },
    { 0, 2, nil, 4, nil, 5, nil, 7, 9, nil, 11, nil },
    { nil, 0, 2, nil, 4, nil, 5, nil, 7, 9, nil, 11 },
    { 0, nil, 2, 4, nil, 5, nil, 7, nil, 9, 11, nil },
    { nil, 0, nil, 2, 4, nil, 5, nil, 7, nil, 9, 11 },
}

local function pitch_to_use(center, pitch_wo_acc)
    return tone_table[(center + 1) % 12][(pitch_wo_acc + 1) % 12]
end

---与えられたノートの表現から (Octave, Pitch, Accidential) の3つ組を計算する。
---@param note string
function M.note_to_tuple(note)
    local octave_dict = { [",,"] = 1, [","] = 2, [""] = 3, ["'"] = 4, ["''"] = 5 }
    local acc_dict = { ["eses"] = -2, ["es"] = -1, [""] = 0, ["is"] = 1, ["isis"] = 2 }
    local pitch_dict = { c = 0, d = 2, e = 4, f = 5, g = 7, a = 9, b = 11 }
    local pitch, acc, octave = parse_note(note)
    return {
        octave_dict[octave],
        pitch_dict[pitch],
        acc_dict[acc],
    }
end

---与えられた key の表現から tonal center を数値で返す。
---@param key string
function M.key_to_center(key)
    local acc_dict = { ["eses"] = -2, ["es"] = -1, [""] = 0, ["is"] = 1, ["isis"] = 2 }
    local pitch_dict = { c = 0, d = 2, e = 4, f = 5, g = 7, a = 9, b = 11 }
    local tonality_dict = { [ [[\major]] ] = 0, [ [[\minor]] ] = 9 }
    local key_pitch, key_acc, tonality = parse_key(key)
    return (pitch_dict[key_pitch] + acc_dict[key_acc] + tonality_dict[tonality] + 12) % 12
end

function M.tuple_to_note(t)
    local octave = t[1]
    local pitch = t[2]
    local acc = t[3]
    local octave_dict = { [1] = ",,", [2] = ",", [3] = "", [4] = "'", [5] = "''" }
    local pitch_dict = { [0] = "c", [2] = "d", [4] = "e", [5] = "f", [7] = "g", [9] = "a", [11] = "b" }
    local acc_dict = { [-2] = "eses", [-1] = "es", [0] = "", [1] = "is", [2] = "isis" }
    return pitch_dict[pitch] .. acc_dict[acc] .. octave_dict[octave]
end

---@param t [integer, integer, integer]
---@return integer
function M.tuple_to_id(t)
    return t[1] * 12 + t[2] + t[3]
end

---@param note string
function M.pre_normalize(note)
    note = note:gsub("^as", "aes")
    note = note:gsub("^es", "ees")
    return note
end

---正規化後の note を返す。
---@param note string
---@param key string
---@return string
function M.normalize_note(note, key)
    note = M.pre_normalize(note)

    local tonal_center_pitch = M.key_to_center(key)
    local note_tuple = M.note_to_tuple(note)
    local note_id = M.tuple_to_id(note_tuple)
    local pitch_wo_acc = note_id % 12
    local pitch = pitch_to_use(tonal_center_pitch, pitch_wo_acc)
    if pitch == nil then
        return note
    end
    local acc = pitch_wo_acc - pitch

    return M.tuple_to_note {
        note_tuple[1],
        pitch,
        acc,
    }
end

return M
