" ~/.config/nvim/init.vim

" =============================
" Basic settings
" =============================
set number
set relativenumber
set expandtab
set shiftwidth=4
set tabstop=4
set smartindent
set cursorline
set termguicolors
set updatetime=300
let mapleader = ","

" =============================
" vim-plug setup
" =============================
call plug#begin('~/.local/share/nvim/plugged')

" Colorscheme
Plug 'morhetz/gruvbox'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Go.nvim
Plug 'ray-x/go.nvim'
Plug 'ray-x/guihua.lua'

" Autocomplete & Snippets
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" File explorer vertical (bên trái)
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

call plug#end()

" =============================
" Colorscheme
" =============================
colorscheme gruvbox
set background=dark

" =============================
" Treesitter setup
" =============================
autocmd BufRead,BufNewFile *.go :TSBufEnable highlight
autocmd BufRead,BufNewFile *.go :TSBufEnable indent

" =============================
" nvim-tree setup (vertical left)
" =============================
lua << EOF
require("nvim-tree").setup({
    auto_reload_on_write = true,
    hijack_cursor = true,
    update_focused_file = { enable = true, update_cwd = true },
    view = {
        width = 30,
        side = "left",
        preserve_window_proportions = true,
        number = true,
        relativenumber = false,
    },
})
EOF

" Auto open tree when nvim starts on folder
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | execute 'NvimTreeOpen' | endif

" =============================
" Keymaps for nvim-tree
" =============================
nnoremap <leader>n :NvimTreeToggle<CR>   " toggle tree
nnoremap <leader>r :NvimTreeRefresh<CR>  " refresh tree
nnoremap <leader>f :NvimTreeFindFile<CR> " focus file in tree

" =============================
" Go.nvim setup
" =============================
autocmd FileType go :lua require("go").setup({
\ goimport = "gopls",
\ gofmt = "golines",
\ max_line_len = 120,
\ tag_transform = false,
\ test_runner = "gotests",
\ lsp_cfg = false,
\ lsp_gofumpt = true,
\})

" =============================
" Keymaps for go.nvim
" =============================
nnoremap <leader>gb :lua require("go.build").build()<CR>
nnoremap <leader>gr :lua require("go.run").run()<CR>
nnoremap <leader>gt :lua require("go.test").test()<CR>
nnoremap <leader>gd :lua require("go.doc").doc()<CR>
nnoremap <leader>gi :lua require("go.install").install()<CR>
nnoremap <leader>gg :lua require("go.generate").generate()<CR>
nnoremap <leader>gj :lua require("go.def").definition()<CR>

" =============================
" LSP gopls setup
" =============================
autocmd FileType go :lua vim.lsp.start({
\ name = "gopls",
\ cmd = {"gopls"},
\ root_dir = vim.loop.cwd(),
\ capabilities = vim.lsp.protocol.make_client_capabilities(),
\ on_attach = function(client, bufnr)
\   local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
\   local opts = { noremap=true, silent=true }
\   buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
\   buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
\   buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
\   buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
\   buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
\ end,
\ flags = { debounce_text_changes = 150 },
\})

" =============================
" nvim-cmp setup
" =============================
autocmd FileType go :lua require'cmp'.setup({
\ snippet = { expand = function(args) require'luasnip'.lsp_expand(args.body) end },
\ mapping = require'cmp'.mapping.preset.insert({
\   ['<CR>'] = require'cmp'.mapping.confirm({ select = true }),
\   ['<C-Space>'] = require'cmp'.mapping.complete(),
\ }),
\ sources = {
\   { name = 'nvim_lsp' },
\   { name = 'buffer' },
\   { name = 'luasnip' },
\ },
\ completion = { autocomplete = { require'cmp'.TriggerEvent.TextChanged } },
\})

" =============================
" Auto hover popup
" =============================
autocmd CursorHold *.go :lua vim.lsp.buf.hover()

" =============================
" Signature help on '('
" =============================
autocmd InsertCharPre *.go :lua if vim.v.char=='(' then vim.lsp.buf.signature_help() end

" =============================
" Highlight yanked text
" =============================
augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=150}
augroup END

" Chuyển focus sang tree bên trái
command! L wincmd h

" Chuyển focus sang code (bên phải)
command! R wincmd l

" Tạo terminal horizontal dưới cùng (10 dòng)
command! T botright 10split term://bash

" Chuyển focus xuống terminal dưới
command! B wincmd j

tnoremap <Esc> <C-\><C-n>

tnoremap <C-r> <C-\><C-n><C-w>l
