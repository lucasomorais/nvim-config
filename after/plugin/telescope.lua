local builtin = require('telescope.builtin')

-- Adicione essa parte do setup:
require('telescope').setup {
  defaults = {
    preview = {
      treesitter = false, -- Desliga o treesitter no preview para evitar o erro
    },
  },
}

vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
