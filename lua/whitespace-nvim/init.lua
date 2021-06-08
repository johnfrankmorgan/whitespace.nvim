local setup = function (options)
  local defaults = {
    highlight = 'DiffDelete',
    ignored_filetypes = { 'TelescopePrompt' }
  }

  options = vim.tbl_extend('force', defaults, options)

  if not vim.fn.hlexists(options.highlight) then
    error(string.format('highlight %s does not exist', options.highlight))
  end

  _G.highlight_trailing_whitespace = function ()
    if vim.tbl_contains(options.ignored_filetypes, vim.bo.filetype) then
      return
    end

    local command = string.format([[match %s /\s\+$/]], options.highlight)

    vim.cmd(command)
  end

  _G.trim_trailing_whitespace = function ()
    vim.cmd [[%substitute/\v\s+$//g]]
  end



  vim.cmd [[
    augroup whitespace_nvim
      autocmd!
      autocmd FileType * call v:lua.highlight_trailing_whitespace()
    augroup END
  ]]
end

return { setup = setup }
