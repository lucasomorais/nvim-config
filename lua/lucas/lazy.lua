-- lua/lucas/lazy.lua

-- 1. Bootstrap do Lazy (Instala sozinho se não existir)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.loop or vim.uv).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Setup dos Plugins
require("lazy").setup({


	-- Harpoon
  {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      -- Adiciona o arquivo atual à lista do Harpoon
      vim.keymap.set("n", "<leader>a", mark.add_file)

      -- Abre o menu flutuante com a lista de arquivos
      vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

      -- Navegação rápida (Arquivos 1, 2, 3 e 4)
      vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
      vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
      vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
      vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)
    end
  },

  -- Undotree
  {
    'mbbill/undotree',
    config = function()
      -- Atalho para abrir/fechar a árvore de desfazer
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- Rose Pine (Tema)
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      vim.cmd('colorscheme rose-pine')
    end
  },

 -- Treesitter (Blindado contra falha de primeira instalação)
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',

    config = function()
      -- Tenta carregar. Se falhar (porque ainda está instalando), retorna silenciosamente.
      local status_ok, configs = pcall(require, "nvim-treesitter.configs")
      if not status_ok then
        return
      end

      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "go", "rust", "javascript" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end
  }
})
