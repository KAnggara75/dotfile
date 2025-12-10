require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

lspconfig.gopls.setup {
    settings = {
        gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = {
                unusedvariable = true,
                unusedparams = true
            }
        }
    }
}
