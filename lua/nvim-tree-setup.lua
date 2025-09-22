-- ~/.config/nvim/lua/nvim-tree-setup.lua
require("nvim-tree").setup({
    auto_reload_on_write = true,
    hijack_cursor = true,
    view = {
        width = 30,
        side = "left",
        preserve_window_proportions = true,
        number = true,
        relativenumber = false,
    },
    update_focused_file = { enable = true, update_cwd = true },
})
