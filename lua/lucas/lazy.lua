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

require("lazy").setup({
    -- LSP e Gerenciamento de Servidores
    { "williamboman/mason.nvim", config = true },
    { "williamboman/mason-lspconfig.nvim", config = true },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("lucas.lsp")
        end
    },

    -- Harpoon para navegação rápida
    {
        'ThePrimeagen/harpoon',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")
            vim.keymap.set("n", "<leader>a", mark.add_file)
            vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
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
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end
    },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

   -- NOVO TEMA: Catppuccin (Mais vibrante)
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            -- O pcall evita que o Neovim trave se o módulo não for encontrado na primeira vez
            local status, configs = pcall(require, "nvim-treesitter.configs")
            if not status then 
                return 
            end

            configs.setup({
                -- Adicionamos o "go" de volta para garantir a cor nas funções
                ensure_installed = { "lua", "vim", "vimdoc", "go", "javascript", "c" }, 
                
                -- sync_install como true fará o Neovim esperar a compilação terminar
                sync_install = true, 
                
                -- auto_install ajuda se você abrir arquivos de outras linguagens
                auto_install = true,

                highlight = {
                    enable = true, -- ISSO é o que colore as funções
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },
})
