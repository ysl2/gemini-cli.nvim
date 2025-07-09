local M = {}

function M.check()
  vim.health.start("Checking gemini.nvim")

  -- Check for the 'gemini' executable
  if vim.fn.executable('gemini') == 1 then
    vim.health.ok("`gemini` executable is found in PATH.")
  else
    vim.health.error("`gemini` executable not found.", {
      "Please install the Gemini CLI.",
      "See https://github.com/google/gemini-cli for installation instructions."
    })
  end

  -- Check for Node.js version
  if vim.fn.executable('node') == 1 then
    local version_str = vim.fn.system('node --version')
    local major_version = tonumber(string.match(version_str, "v(%d+)"))
    if major_version then
      if major_version >= 20 then
        vim.health.ok("Node.js version is " .. version_str:gsub('\n', '') .. " (>= 20).")
      else
        vim.health.warn("Node.js version is " .. version_str:gsub('\n', '') .. ". Version 20 or higher is recommended.")
      end
    else
      vim.health.warn("Could not parse Node.js version string: " .. version_str:gsub('\n', ''))
    end
  else
    vim.health.error("`node` executable not found. Node.js is required.")
  end
end

return M
