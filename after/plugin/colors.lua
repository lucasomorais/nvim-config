function ColorMyPencils(color)
    -- Mudamos para catppuccin-mocha (versão escura e vibrante)
    color = color or "catppuccin-mocha"
    local status, _ = pcall(vim.cmd.colorscheme, color)
    if not status then return end

    -- Transparência
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()
