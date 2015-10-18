
" don't bother with vi compatibility
set nocompatible

" enable syntax highlighting
syntax enable

" configure Vundle
filetype on " without this vim emits a zero exit status, later, because of :ft off
filetype off
set rtp+=~/.config/nvim/autoload/plugin.vim
call plug#begin()

" install Vundle bundles
if filereadable(expand("~/.config/nvim/vimrc.bundles"))
  source ~/.config/nvim/vimrc.bundles
  source ~/.vimrc.bundles.local
endif

call plug#end()

" ensure ftdetect et al work by including this after the Vundle stuff
filetype plugin indent on

set autoindent
set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set backspace=2                                              " Fix broken backspace in some setups
set backupcopy=yes                                           " see :help crontab
set clipboard=unnamed                                        " yank and paste with the system clipboard
set directory-=.                                             " don't store swapfiles in the current directory
set expandtab                                                " expand tabs to spaces
set ignorecase                                               " case-insensitive search
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline
set list                                                     " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set number                                                   " show line numbers
set ruler                                                    " show where you are
set scrolloff=3                                              " show context above/below cursorline
set shiftwidth=2                                             " normal mode indentation commands use 2 spaces
set showcmd
set smartcase                                                " case-sensitive search if any caps
set softtabstop=2                                            " insert mode tab and backspace use 2 spaces
set tabstop=8                                                " actual tabs occupy 8 characters
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list,full

" keyboard shortcuts
let mapleader = ','
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <leader>l :Align
nnoremap <leader>a :Ag<space>
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>
nnoremap <leader>] :TagbarToggle<CR>
nnoremap <leader>z :GundoToggle<CR>
nnoremap <leader>g :GitGutterToggle<CR>
nmap <silent> <leader>D <Plug>DashSearch
nnoremap <leader><leader>m :YcmCompleter GoToDefinition<CR>
nnoremap <leader><leader>h :YcmCompleter GoToDeclaration<CR>
nnoremap <leader><space> :call whitespace#strip_trailing()<CR>
noremap <silent> <leader>V :source ~/.config/nvim/init.vim<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" Neoterm
" let g:neoterm_position = 'horizontal'
" let g:neoterm_size = 10

" nnoremap <leader>t :Ttoggle<CR>
" nnoremap <silent> <leader>tf :TREPLSendFile<CR>
" nnoremap <silent> <leader>tl :TREPLSendLine<CR>
" vnoremap <silent> <leader>ts :TREPLSendSelection<CR>

" nnoremap <silent> <leader>th :call neoterm#close()<CR>
" nnoremap <silent> <leader>tr :call neoterm#clear()<CR>
" nnoremap <silent> <leader>tc :call neoterm#kill()<CR>


" fix insert mode can not get correct cursor change
set cursorline
autocmd VimEnter * highlight CursorLine ctermbg=NONE guibg=NONE
autocmd InsertEnter * highlight CursorLine ctermbg=18 guibg=18
autocmd InsertLeave * highlight CursorLine ctermbg=NONE guibg=NONE

" in case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %

" plugin settings
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:NERDSpaceDelims=1
let g:gitgutter_enabled = 0

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" synchronize directory
autocmd BufEnter * lcd %:p:h
" fdoc is yaml
autocmd BufRead,BufNewFile *.fdoc set filetype=yaml
" md is markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.md set spell
" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

" indent guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" fold
set foldmethod=syntax
set nofoldenable

" youCompleteMe
let g:ycm_global_ycm_extra_conf = "~/.config/nvim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"

let g:ycm_key_list_select_completion = ['<TAB>']
let g:ycm_key_list_previous_completion = ['<S-TAB>']
let g:ycm_complete_in_comments = 1  "在注释输入中也能补全
let g:ycm_complete_in_strings = 1   "在字符串输入中也能补全
let g:ycm_collect_identifiers_from_comments_and_strings = 1   "注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_goto_buffer_command = 'horizontal-split'

let g:UltiSnipsExpandTrigger = '<c-space>'

" neomake
autocmd! BufWritePost * Neomake

let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_ruby_enabled_makers = ['rubocop']

let g:neomake_error_sign = {'text': 'e', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {
  \   'text': 'w',
  \   'texthl': 'NeomakeWarningSign',
  \ }
let g:neomake_message_sign = {
  \   'text': 'm',
  \   'texthl': 'NeomakeMessageSign',
  \ }
let g:neomake_info_sign = {'text': 'i', 'texthl': 'NeomakeInfoSign'}

" airline
let g:airline#extensions#tabline#enabled = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline#extensions#tabline#buffer_idx_mode = 1

" nvimux
let g:nvimux_prefix='<C-a>'

" support none utf-8 encoding
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

" keyboard shortcuts
inoremap jj <ESC>

" highlight search
set hlsearch
"nmap <leader>hl :let @/ = ""<CR>

let g:solarized_termcolors=256
set background=dark
colorscheme solarized

" code line guide
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Disambiguate ,a & ,t from the Align plugin, making them fast again.
"
" This section is here to prevent AlignMaps from adding a bunch of mappings
" that interfere with the very-common ,a and ,t mappings. This will get run
" at every startup to remove the AlignMaps for the *next* vim startup.
"
" If you do want the AlignMaps mappings, remove this section, remove
" ~/.vim/bundle/Align, and re-run rake in maximum-awesome.
function! s:RemoveConflictingAlignMaps()
  if exists("g:loaded_AlignMapsPlugin")
    AlignMapsClean
  endif
endfunction
command! -nargs=0 RemoveConflictingAlignMaps call s:RemoveConflictingAlignMaps()
silent! autocmd VimEnter * RemoveConflictingAlignMaps
