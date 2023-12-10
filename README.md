# aws-sdk.nvim
This is a simple plugin to quickly view node aws sdk commands.

## Installation
Example using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
-- init.lua:
{
  'harryvince/aws-sdk.nvim',
  dependencies = { 
    { 'nvim-telescope/telescope.nvim' },
    { 'nvim-lua/plenary.nvim' }
  },
  config = function ()
      local aws = require('aws-sdk')

      vim.keymap.set('n', '<leader>aws', aws.find_command)
  end
}

-- plugins/aws-sdk.lua:
return {
      'harryvince/aws-sdk.nvim',
      dependencies = { 
        { 'nvim-telescope/telescope.nvim' },
        { 'nvim-lua/plenary.nvim' }
      },
      config = function ()
          local aws = require('aws-sdk')

          vim.keymap.set('n', '<leader>aws', aws.find_command)
      end
}
```
