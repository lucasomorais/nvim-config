require("lucas.remap")
require("lucas.lazy")
require("lucas.set")
require("lucas.lsp")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.treesitter.start()
    end,
})
