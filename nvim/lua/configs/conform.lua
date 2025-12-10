local options = {
    formatters_by_ft = {
        lua = {"stylua"},
        go = {"gofmt", "goimports"}
    },

    format_on_save = {
        timeout_ms = 500
    }
}

return options
