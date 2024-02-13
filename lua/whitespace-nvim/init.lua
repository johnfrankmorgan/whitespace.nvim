local config = {
  highlight = 'DiffDelete',
  ignored_filetypes = { 'TelescopePrompt', 'Trouble', 'help' },
  ignore_terminal = true,
  return_cursor = true,
}

local whitespace = {}

whitespace.highlight = function ()
  if not vim.fn.hlexists(config.highlight) then
    error(string.format('highlight %s does not exist', config.highlight))
  end

  if config.ignore_terminal and vim.bo.buftype == 'terminal' then
    return
  end

  if vim.tbl_contains(config.ignored_filetypes, vim.bo.filetype) then
    return
  end

  local command = string.format([[match %s /\s\+$/]], config.highlight)
  vim.cmd(command)
end

whitespace.trim = function ()
  local save_cursor = vim.fn.getpos(".")

  vim.cmd [[keeppatterns %substitute/\v\s+$//eg]]

  if config.return_cursor then
    vim.fn.setpos(".", save_cursor)
  end
end

whitespace.setup = function (options)
  config = vim.tbl_extend('force', config, options or {})

  vim.cmd [[
    augroup whitespace_nvim
      autocmd!
      autocmd FileType * lua require('whitespace-nvim').highlight()
    augroup END
  ]]
end

return whitespace
