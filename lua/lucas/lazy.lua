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
    -- === 1. O BÁSICO (Mason para baixar os programas) ===
    { "williamboman/mason.nvim", config = true },
    -- Nota: Mantemos este plugin apenas para o Mason saber onde instalar, 
    -- mas não vamos usá-lo para configurar o C#
    { "williamboman/mason-lspconfig.nvim", config = true },
    
    -- === 2. CONFIGURAÇÃO PURA DO LSP (Sem plugin lspconfig para C#) ===
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- Carregamos suas configs do lucas.lsp se existirem
            local status, lsp_setup = pcall(require, "lucas.lsp")
            local caps = vim.lsp.protocol.make_client_capabilities()
            local attach = nil

            if status and type(lsp_setup) == "table" then
                caps = lsp_setup.capabilities or caps
                attach = lsp_setup.on_attach
            end

            -- AQUI ESTÁ A MÁGICA: Automação Nativa
            -- Isso roda toda vez que você abre um arquivo .cs
            -- Ignora plugins deprecados e fala direto com o Neovim
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "cs",
                callback = function(args)
                    -- 1. Achar onde está o OmniSharp que o Mason baixou
                    local omnisharp_dll = vim.fn.stdpath("data") .. "/mason/packages/omnisharp/libexec/OmniSharp.dll"
                    
                    -- 2. Achar a raiz do projeto (onde está o .csproj)
                    local root = vim.fs.find({ '*.sln', '*.csproj', '.git' }, { path = args.file, upward = true })[1]
                    if root then root = vim.fs.dirname(root) end

                    if not root then
                        print("Aviso: Nenhum arquivo .csproj encontrado. LSP de C# não iniciará.")
                        return
                    end

                    -- 3. Iniciar o servidor manualmente (Bypass de plugins)
                    vim.lsp.start({
                        name = "omnisharp",
                        cmd = { "dotnet", omnisharp_dll },
                        root_dir = root,
                        capabilities = caps,
                        on_attach = attach,
                        settings = {
                            FormattingOptions = { EnableEditorConfigSupport = true },
                            RoslynExtensionsOptions = { EnableAnalyzersSupport = true },
                        }
                    })
                end,
            })
        end
    },

    -- === 3. FERRAMENTAS EXTRAS ===
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
    { 'mbbill/undotree', config = function() vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle) end },
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    -- === 4. TREESITTER (Cores) ===
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            -- Proteção de disco
            local plugin_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/lua/nvim-treesitter/configs.lua"
            if vim.fn.filereadable(plugin_path) == 0 then return end

            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "vim", "vimdoc", "go", "javascript", "c", "c_sharp" },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },
})

-- === 5. GARANTIA DE CORES ===
vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function()
        pcall(vim.treesitter.start)
    end,
})
