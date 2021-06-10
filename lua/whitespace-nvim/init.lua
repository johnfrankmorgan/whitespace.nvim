local config = {
  highlight = 'DiffDelete',
  ignored_filetypes = { 'TelescopePrompt' },
}

local whitespace = {}

whitespace.highlight = function ()
  if not vim.fn.hlexists(config.highlight) then
    error(string.format('highlight %s does not exist', config.highlight))
  end

  if vim.tbl_contains(config.ignored_filetypes, vim.bo.filetype) then
    return
  end

  local command = string.format([[match %s /\s\+$/]], config.highlight)
  vim.cmd(command)
end

whitespace.trim = function ()
  vim.cmd [[%substitute/\v\s+$//g]]
end

whitespace.setup = function (options)
  config = vim.tbl_extend('force', config, options)

  vim.cmd [[
    augroup whitespace_nvim
      autocmd!
      autocmd FileType * lua require('whitespace-nvim').highlight()
    augroup END
  ]]
end

return whitespace
