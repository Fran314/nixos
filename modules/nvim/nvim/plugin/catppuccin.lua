require("catppuccin").setup({
    flavour = "macchiato",
    transparent_background = true,
})
vim.cmd.colorscheme("catppuccin")

vim.api.nvim_command("hi LineNr guifg=#BBBBBB")

vim.api.nvim_command("hi Normal guibg=NONE ctermbg=NONE")
vim.api.nvim_command("hi EndOfBuffer guibg=NONE ctermbg=NONE")
vim.api.nvim_command("hi SignColumn guibg=NONE ctermbg=NONE")
vim.api.nvim_command("hi BufferTabpageFill guibg=NONE ctermbg=NONE")
