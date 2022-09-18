# 🌳 lsp-rooter.nvim

**Lsp Rooter** is a Neovim plugin written in Lua to change the current working
directory to the project's root directory automatically using Neovim's native
LSP client.

<img src="https://user-images.githubusercontent.com/36672196/119023256-a9432800-b9b2-11eb-8f0e-028a860efa9c.gif">

## ✨ Features

- Automatically cd to project directory using Neovim's LSP client
- Dependency free, does not rely on `lspconfig`
- nvim-tree.lua support/integration

## ⚡️ Requirements

- Neovim >= 0.7.0

## 📦 Installation

Install the plugin with your preferred package manager:

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
" Vim Script
Plug 'poljar/lsp-rooter.nvim'

lua << EOF
  require("lsp-rooter").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF
```

### [packer](https://github.com/wbthomason/packer.nvim)

```lua
-- Lua
use {
    "poljar/lsp-rooter.nvim",
    config = function()
        require("lsp-rooter").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        }
    end
}
```

## ⚙️ Configuration

**Lsp Rooter** comes with the following defaults:

```lua
{
  -- Table of lsp clients to ignore by name
  -- eg: {"efm", ...}
  ignore_lsp = {},
}
```
