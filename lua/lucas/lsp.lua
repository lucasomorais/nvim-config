-- Configuração para Neovim 0.11+
vim.lsp.config('gopls', {
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
})

-- Ativa o servidor gopls
vim.lsp.enable('gopls')

-- Atalhos de navegação
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})          -- Documentação
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})    -- Ir para definição
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})    -- Ver referências
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {}) -- Ver erro detalhado
