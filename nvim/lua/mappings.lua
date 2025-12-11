require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", {
    desc = "CMD enter command mode"
})
map("i", "jk", "<ESC>")

map("n", "<M-]>", "<cmd>bnext<CR>", {
    desc = "Next Buffer"
})

map("n", "<C-q>", "<cmd>bdelete<CR>", {
    desc = "Close Buffer"
})

map("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", {
    desc = "Toggle Explorer"
})
map("n", "<C-p>", "<cmd>Telescope find_files<CR>", {
    desc = "Find Files"
})
map("n", "<C-S-f>", "<cmd>Telescope live_grep<CR>", {
    desc = "Search in Project"
})
