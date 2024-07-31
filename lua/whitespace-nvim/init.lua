local config = {
  highlight = 'DiffDelete',
  ignored_filetypes = { 'TelescopePrompt', 'Trouble', 'help', 'dashboard' },
  ignore_terminal = true,
  return_cursor = true,
}

local whitespace = {}

whitespace.clean = function()
  vim.cmd('match')
end

whitespace.highlight = function()
  if not vim.fn.hlexists(config.highlight) then
    error(string.format('highlight %s does not exist', config.highlight))
  end

  local command = string.format([[match %s /\s\+$/]], config.highlight)
  vim.cmd(command)
end

whitespace.trim = function()
  local save_cursor = vim.fn.getpos(".")

  vim.cmd [[keeppatterns %substitute/\v\s+$//eg]]

  if config.return_cursor then
    vim.fn.setpos(".", save_cursor)
  end
end

local function file_type()
  if vim.tbl_contains(config.ignored_filetypes, vim.bo.filetype) then
    whitespace.clean()
    return
  end
  whitespace.highlight()
end

local function term_open()
  if config.ignore_terminal then
    whitespace.clean()
  else
    whitespace.highlight()
  end
end

whitespace.setup = function(options)
  config = vim.tbl_extend('force', config, options or {})

  vim.api.nvim_create_augroup('whitespace_nvim', {clear = true})
  vim.api.nvim_create_autocmd('FileType', {group = 'whitespace_nvim', pattern = '*', callback = file_type})
  vim.api.nvim_create_autocmd('TermOpen', {group = 'whitespace_nvim', pattern = '*', callback = term_open})
end

return whitespace
