# whitespace.nvim

This is a simple neovim plugin to highlight and remove trailing whitespace.

## Installation

```lua
-- Using packer.nvim
use {
    'johnfrankmorgan/whitespace.nvim',
    config = function ()
        require('whitespace-nvim').setup({
            -- configuration options and their defaults

            -- `highlight` configures which highlight is used to display
            -- trailing whitespace
            highlight = 'DiffDelete'

            -- `ignored_filetypes` configures which filetypes to ignore when
            -- displaying trailing whitespace
            ignored_filetypes = { 'TelescopePrompt' },
        })

        -- remove trailing whitespace with a keybinding
        vim.api.nvim_set_keymap(
            'n',
            '<Leader>t',
            [[<cmd>lua require('whitespace-nvim').trim()<CR>]]
            { noremap = true }
        )
    end
}
```
