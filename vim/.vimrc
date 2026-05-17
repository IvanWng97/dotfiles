""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set spelllang=en_us
set spelllang+=cjk
set spell
syntax on
filetype on
filetype plugin on
autocmd BufNewFile,BufRead *.json setl ft=jsonc
autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']

"""""" netrw """"""
let g:netrw_fastbrowse = 0
let g:netrw_banner=0
let g:netrw_keepdir = 0
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_browse_split = 4
autocmd FileType netrw setl bufhidden=wipe

"""""" command completion """"""
set wildmenu
set wildmode=longest:full,full
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx,*DS_STORE,*.db

"""""" folding """"""
set foldmethod=indent       " fold based on indent
set foldnestmax=10          " deepest fold is 20 levels
set nofoldenable            " don't fold by default
set foldlevel=2

"""""" tab and indentation """"""
set tabstop=4                   " Tab is 4 spaces
set shiftwidth=4				" The # of spaces for indenting.
set softtabstop=4				" Tab key results in # spaces
set ai					" Tab key results in # spaces"Auto indent
set si "Smart indent
set smarttab
set expandtab           "convert tabs to spaces
set nu!                 "toggle the line numbers
set backspace=indent,eol,start
set autoindent smartindent

set mouse=a
set clipboard=unnamed
set nocompatible
set showcmd
set autoread                " reload files if changed externally
set ignorecase smartcase
set hlsearch                " highlight searches
set pumheight=10
set noshowmode              " we don't need to see things like -- INSERT -- anymore
set undofile                " enable persistent undo
set nobackup nowritebackup

set sidescrolloff=5         " Start scrolling n chars before end of screen.

"""""" UI """"""
set termguicolors
autocmd colorscheme * highlight DiffAdd gui=none guifg=#A1C281 guibg=None
autocmd colorscheme * highlight DiffChange gui=none guifg=#74ADEA guibg=None
autocmd colorscheme * highlight DiffDelete gui=none guifg=#FE747A guibg=None

set guicursor=i:ver100-blinkon100
            \,r:hor100

"""""" remap """"""
let mapleader = ','
nmap <A-a> ggVG
imap <A-a> <Esc>ggVG

nmap <A-o> <cmd>lua require('telescope.builtin').find_files()<cr>
imap <A-o> <Esc><cmd>lua require('telescope.builtin').find_files()<cr>

nmap <A-p> <cmd>lua require('telescope.builtin').commands()<cr>
imap <A-p> <Esc><cmd>lua require('telescope.builtin').commands()<cr>
nmap <A-S-p> <cmd>lua require('telescope.builtin').builtin()<cr>
imap <A-S-p> <Esc><cmd>lua require('telescope.builtin').builtin()<cr>

nmap <A-g> <cmd>lua require('telescope.builtin').live_grep()<cr>
imap <A-g> <Esc><cmd>lua require('telescope.builtin').live_grep()<cr>

nmap <A-f> <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>
imap <A-f> <Esc><cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>


nmap <A-e> :NvimTreeToggle<CR>
imap <A-e> <Esc>:NvimTreeToggle<CR>
nmap <A-r> :NvimTreeRefresh<CR>

nmap <A-s> :w<CR>
imap <A-s> <Esc>:w<CR>
nmap <A-q> :q<CR>
nmap <A-S-q> :qa!<CR>
nmap <A-/> :lua require("Comment.api").toggle_current_linewise()<CR>
vmap <A-/> :lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>
imap <A-/> <Esc>:lua require("Comment.api").toggle_current_linewise()<CR>

nmap <A-w> :bd<CR>
imap <A-w> <Esc>:bd<CR>
imap <C-r> <Esc><C-r>
imap <leader>z <Esc>u
nmap <space> :
map <A-d> "_dd

"nmap  <silent>   <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
function! TabEnable()
    let num = winnr('$')
    if num == 1
        return ":bnext\<CR>"
    else
        return "\<C-W>w"
    endif
endfunction
nmap <expr> <silent> <Tab> TabEnable()

nmap <silent> <leader>] :BufferLineCycleNext<CR>
imap <silent> <leader>] :BufferLineCycleNext<CR>

nnoremap <silent><leader>[ :BufferLineCyclePrev<CR>
inoremap <silent><leader>[ :BufferLineCyclePrev<CR>

nmap <silent><expr> <f2> ':set wrap! go'.'-+'[&wrap]."=b\r"
command! -nargs=0 UpdateAll :exe "TSUpdate" | exe "PlugUpdate" | exe "PlugUpgrade"

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50
let g:cursorhold_updatetime = 100

" Don't pass messages to |ins-completion-menu|.
" set shortmess+=c

if has('nvim')
    set signcolumn=yes:1
else
    set signcolumn=yes
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Setting for vimspector
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
let g:vimspector_install_gadgets = [
    \ 'CodeLLDB',
    \ 'debugpy',
    \ ]

