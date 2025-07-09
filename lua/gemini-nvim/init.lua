-- Stores the buffer and window IDs to manage the Gemini terminal session.
local gemini_session = {
  buf = nil,
  win = nil,
}

-- Defines the configuration for the floating window.
local function get_win_config()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
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

vim.api.nvim_create_user_command('Gemini', function()
  -- If the window is already visible, hide it by closing it.
  -- The bufhidden property will keep the buffer and terminal process alive.
  if gemini_session.win and vim.api.nvim_win_is_valid(gemini_session.win) then
    vim.api.nvim_win_close(gemini_session.win, false)
    gemini_session.win = nil
    return
  end

  -- If the buffer exists but the window is hidden, just show the window again.
  if gemini_session.buf and vim.api.nvim_buf_is_valid(gemini_session.buf) then
    gemini_session.win = vim.api.nvim_open_win(gemini_session.buf, true, get_win_config())
    return
  end

  -- First run: Create the server, buffer, process, and window.

  -- Ensure the neovim server is running.
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

  -- Create a new buffer for the terminal.
  gemini_session.buf = vim.api.nvim_create_buf(false, true)
  -- This is the key: Keep the buffer loaded when its window is closed.
  vim.bo[gemini_session.buf].bufhidden = 'hide'

  -- Create the floating window.
  gemini_session.win = vim.api.nvim_open_win(gemini_session.buf, true, get_win_config())

  -- Start the Gemini process in the terminal.
  local cmd_to_run = string.format("NVIM_LISTEN_ADDRESS='%s' gemini", server_addr)
  vim.fn.jobstart(cmd_to_run, { term = true })
end, { nargs = 0, desc = 'Show, hide, or run Gemini in a floating terminal' })
