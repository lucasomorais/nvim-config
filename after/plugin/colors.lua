function ColorMyPencils(color)
    color = color or "catppuccin-mocha"
    local status, _ = pcall(vim.cmd.colorscheme, color)
    if not status then return end
end

ColorMyPencils()
