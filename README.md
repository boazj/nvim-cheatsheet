# nvim-cheatsheet



# Installation Using [Lazy](https://github.com/folke/lazy.nvim)

```lua
  {
    'boazj/nvim-cheatsheet',
    config = function()
      require('cheatsheet').setup {
        excluded_groups = { 'terminal (t)', 'autopairs', 'Nvim', 'Opens', ':help' },
        spec = {
          ['<Leader><F12>'] = 'Maintanance',
          ['<Leader><Leader>'] = 'Search',
          ['<Leader>/'] = 'Search',
          ['<Leader>,'] = 'Search',
          ['<Leader>s'] = 'Search',
          ['<Leader>l'] = 'Neovim',
          ['<Leader>``'] = 'Neovim',
          ['<Leader>r'] = 'Refactor',
          ['<Leader>g'] = 'GIT',
          ['[b'] = 'Buffers',
          [']b'] = 'Buffers',
          [']B'] = 'Buffers',
          ['[B'] = 'Buffers',
          ['H'] = 'Buffers',
          ['L'] = 'Buffers',
          ['<C-S>'] = 'Buffers',
          ['<Leader>b'] = 'Buffers',
          ['gc'] = 'Comments',
          ['<Leader>c'] = 'Diagnostics',
          [']d'] = 'Diagnostics',
          ['[d'] = 'Diagnostics',
          [']e'] = 'Diagnostics',
          ['[e'] = 'Diagnostics',
          [']w'] = 'Diagnostics',
          ['[w'] = 'Diagnostics',
          ['<C-W>'] = 'Diagnostics',
          ['i'] = 'Motion',
          ['a'] = 'Motion',
        },
      }
    end,
  },
```

# Roadmap

See [TODO.md](TODO.md)


# Credits
* [nvcheatsheet.nvim](https://github.com/smartinellimarco/nvcheatsheet.nvim)
* [NvChad](https://nvchad.com/)
Both projects were huge jumpstart for this plugin
