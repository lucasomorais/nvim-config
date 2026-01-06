local M = {}

-- Configuração das capacidades (necessário para o autocompletar funcionar bem)
M.capabilities = vim.lsp.protocol.make_client_capabilities()

-- Configuração para Neovim 0.11+ (Go)
vim.lsp.config('gopls', {
    capabilities = M.capabilities,
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

-- Atalhos de navegação (Globais)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})          -- Documentação
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})    -- Ir para definição
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})    -- Ver referências
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {}) -- Ver erro detalhado

-- Retornamos a tabela M para que o lazy.lua consiga ler M.capabilities
return M
