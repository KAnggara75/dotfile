return {{
    "mason-org/mason.nvim",
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    }
}, {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = {"gopls"},
        automatic_installation = true
    }
}, {
    "stevearc/conform.nvim",
    opts = require "configs.conform"
}, {
    "neovim/nvim-lspconfig",
    config = function()
        require "configs.lspconfig"
    end
}}
