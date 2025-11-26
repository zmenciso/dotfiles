-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

local function lmap(mode, shortcut, command, opts)
  vim.api.nvim_set_keymap(mode, shortcut, command, opts)
end

-- Terminal
map("n", "<c-t>", function()
  Snacks.terminal()
end, { desc = "Terminal (cwd)" })

-- File manager
lmap("n", "<leader>fx", "<cmd>Xplr<cr>", { noremap = true })

-- Map Ctrl-Backspace to delete the previous word in insert mode.Add
lmap("!", "<C-BS>", "<C-w>", { noremap = true })
lmap("!", "<C-h>", "<C-w>", { noremap = true })

-- Splits
lmap("n", "<c-v>", "<cmd>vsplit<cr>", {})
lmap("n", "<c-x>", "<cmd>split<cr>", {})
