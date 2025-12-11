require("nvchad.configs.lspconfig").defaults()

vim.lsp.config.gopls = {
    default_config = {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = {"gopls"},
        filetypes = {"go", "gomod", "gowork", "gotmpl"},
        root_dir = vim.fs.root(0, {"go.work", "go.mod", ".git"}),
        settings = {
            gopls = {
                completeUnimported = true,
                usePlaceholders = true,
                analyses = {
                    unusedparams = true
                }
            }
        }
    }
}

vim.lsp.enable({"gopls"})

vim.diagnostic.config({
    virtual_text = {
        prefix = "●", -- simbol warna
        spacing = 2
    },
    underline = true,
    signs = true,
    update_in_insert = false
})
