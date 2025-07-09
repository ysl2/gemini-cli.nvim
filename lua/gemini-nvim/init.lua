local M = {}

-- Default configuration, can be overridden by the user in the setup function.
local config = {
  window_style = 'float', -- 'float' or 'side'
  side_position = 'right', -- 'left' or 'right'
  float_width_ratio = 0.8,
  float_height_ratio = 0.8,
}

-- Holds the state of the running Gemini session.
local session = {
  buf = nil,
  win = nil,
}

-- Defines the configuration for the floating window.
local function get_float_win_config()
  local width = math.floor(vim.o.columns * config.float_width_ratio)
  local height = math.floor(vim.o.lines * config.float_height_ratio)
  return {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    border = "rounded",
  }
end

-- Opens the Gemini window based on the user's configuration.
local function open_window()
  if config.window_style == 'float' then
    session.win = vim.api.nvim_open_win(session.buf, true, get_float_win_config())
  else -- 'side'
    if config.side_position == 'left' then
      vim.cmd('topleft vsplit')
    else
      vim.cmd('botright vsplit')
    end
    vim.api.nvim_win_set_buf(0, session.buf)
    session.win = vim.api.nvim_get_current_win()
  end
end

-- The main function for the :Gemini command.
local function gemini_command()
  -- If the window is already visible, hide it.
  if session.win and vim.api.nvim_win_is_valid(session.win) then
    vim.api.nvim_win_close(session.win, false)
    session.win = nil
    return
  end

  -- If the buffer exists but the window is hidden, show it again.
  if session.buf and vim.api.nvim_buf_is_valid(session.buf) then
    open_window()
    return
  end

  -- First run: Create the server, buffer, process, and window.
  local server_addr = vim.v.servername
  if not server_addr or #server_addr == 0 then
    local socket_path = vim.fn.stdpath('run') .. '/gemini-nvim.sock'
    vim.cmd('call serverstart("' .. socket_path .. '")')
    server_addr = vim.v.servername
  end

  if not server_addr or #server_addr == 0 then
    vim.api.nvim_err_writeln("Error: Could not start or find the Neovim server.")
    return
  end

  session.buf = vim.api.nvim_create_buf(false, true)
  vim.bo[session.buf].bufhidden = 'hide'

  open_window()

  local cmd_to_run = string.format("NVIM_LISTEN_ADDRESS='%s' gemini", server_addr)
  vim.fn.jobstart(cmd_to_run, {
    term = true,
    on_exit = function()
      -- Clean up the session state if the process terminates.
      session.buf = nil
      session.win = nil
    end,
  })
end

-- Public setup function for the plugin.
function M.setup(user_config)
  config = vim.tbl_deep_extend('force', config, user_config or {})
  vim.api.nvim_create_user_command('Gemini', gemini_command, {
    nargs = 0,
    desc = 'Show, hide, or run Gemini'
  })
end

return M
