require "nvchad.options"

vim.api.nvim_set_hl(0, "DiagnosticError", {
    fg = "#ff6c6b"
})
vim.api.nvim_set_hl(0, "DiagnosticWarn", {
    fg = "#ECBE7B"
})
vim.api.nvim_set_hl(0, "DiagnosticInfo", {
    fg = "#51afef"
})
vim.api.nvim_set_hl(0, "DiagnosticHint", {
    fg = "#98be65"
})
