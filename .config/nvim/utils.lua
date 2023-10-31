local build_session_command
local function _1_(cmd, path, name)
  return (cmd .. " " .. path .. "/" .. name)
end
build_session_command = _1_
local vim = _G.vim
local M
local function _2_(lhs, rhs)
  return vim.api.nvim_set_keymap("", lhs, rhs, {silent = true, noremap = false})
end
local function _3_(lhs, rhs)
  return vim.api.nvim_set_keymap("n", lhs, rhs, {noremap = true, silent = true})
end
local function _4_(lhs, rhs)
  return vim.api.nvim_set_keymap(0, "n", lhs, rhs, {noremap = true, silent = true})
end
local function _5_(lhs, rhs)
  return vim.api.nvim_set_keymap("i", lhs, ("<c-o>" .. rhs), {noremap = true, silent = true})
end
local function _6_(lhs, rhs)
  return vim.api.nvim_set_keymap("t", lhs, rhs, {noremap = true, silent = true})
end
local function _7_(str, send_output)
  local function _9_()
    local _8_ = send_output
    if (_8_ == true) then
      return true
    elseif true then
      local _ = _8_
      return false
    else
      return nil
    end
  end
  return vim.api.nvim_exec(str, _9_())
end
local function _11_(_3fopts)
  local options = (_3fopts or {})
  local session_name = (options.session_name or "Session.vim")
  local file_path = (options.file_path or vim.fn.FugitiveWorkTree())
  local command = build_session_command("silent! mksession!", file_path, session_name)
  return vim.cmd(command)
end
local function _12_(_3fopts)
  local options = (_3fopts or {})
  local session_name = (options.session_name or "Session.vim")
  local file_path = (options.file_path or ("/tmp/current_session")())
  local command = build_session_command("silent! mksession!", file_path, session_name)
  return vim.cmd(command)
end
local function _13_(_3fopts)
  local options = (_3fopts or {})
  local session_name = (options.session_name or "Session.vim")
  local file_path = (options.file_path or vim.fn.FugitiveWorkTree())
  local command = build_session_command("source", file_path, session_name)
  print(command)
  return vim.cmd(command)
end
local function _14_()
  local view = vim.fn.winsaveview()
  vim.cmd("keepjumps silent %smagic/ *$//")
  return vim.fn.winrestview(view)
end
local function _15_(delimiter)
  local delimiter0 = (delimiter or "\\n")
  local buf_info = vim.fn.getbufinfo()
  local buffer_names
  do
    local tbl_17_auto = {}
    local i_18_auto = #tbl_17_auto
    for _, buffer in ipairs(buf_info) do
      local val_19_auto = vim.fn.fnamemodify(buffer.name, ":~:.")
      if (nil ~= val_19_auto) then
        i_18_auto = (i_18_auto + 1)
        do end (tbl_17_auto)[i_18_auto] = val_19_auto
      else
      end
    end
    buffer_names = tbl_17_auto
  end
  return table.sort(buffer_names)
end
local function _17_()
  return os.execute(("echo \"" .. vim.fn.getcwd() .. "\" > " .. os.getenv("VIM_CWD_PATH")))
end
M = {map = _2_, nnoremap = _3_, buf_nnoremap = _4_, inoremap = _5_, tnoremap = _6_, exec = _7_, make_session_on_git_root = _11_, backup_session = _12_, load_session_from_git_root = _13_, clean_buffer_postspace = _14_, get_listed_bufnames = _15_, export_cwd = _17_}
return M
