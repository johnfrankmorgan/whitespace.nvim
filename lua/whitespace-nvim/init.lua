local config = {
  highlight = "DiffDelete",
  ignored_filetypes = { "TelescopePrompt", "Trouble", "help", "dashboard" },
  ignore_terminal = true,
  return_cursor = true,
}

local whitespace = {}

local function should_highlight()
  if vim.bo.buftype == "nofile" then
    return false
  end

  if config.ignore_terminal and vim.bo.buftype == "terminal" then
    return false
  end

  if vim.tbl_contains(config.ignored_filetypes, vim.bo.filetype) then
    return false
  end

  return true
end

whitespace.highlight = function()
  if not vim.fn.hlexists(config.highlight) then
    error(string.format("highlight %s does not exist", config.highlight))
  end

  if should_highlight() then
    local command = string.format([[match %s /\s\+$/]], config.highlight)
    vim.cmd(command)
  else
    vim.cmd("match")
  end
end

whitespace.trim = function()
  local save_cursor = vim.fn.getpos(".")

  vim.cmd([[keeppatterns %substitute/\v\s+$//eg]])

  if config.return_cursor then
    vim.fn.setpos(".", save_cursor)
  end
end

whitespace.setup = function(options)
  config = vim.tbl_extend("force", config, options or {})

  vim.api.nvim_create_augroup("whitespace_nvim", { clear = true })
  vim.api.nvim_create_autocmd(
    "FileType",
    { group = "whitespace_nvim", pattern = "*", callback = whitespace.highlight }
  )
  vim.api.nvim_create_autocmd(
    "TermOpen",
    { group = "whitespace_nvim", pattern = "*", callback = whitespace.highlight }
  )
  vim.api.nvim_create_autocmd(
    "BufEnter",
    { group = "whitespace_nvim", pattern = "*", callback = whitespace.highlight }
  )
  vim.api.nvim_create_autocmd(
    "UIEnter",
    { group = "whitespace_nvim", pattern = "*", callback = whitespace.highlight }
  )
end

return whitespace
