"" Vundle (needs to be before everything else)
" see :h vundle for more details or wiki for FAQ
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

set nocompatible                  " don't try to be compatible with legacy vi
filetype off
set rtp+=~/.vim/bundle/Vundle.vim " set the runtime path to include Vundle and initialize
set t_Co=256                    " Explicitly tell vim that the terminal supports 256 colors
call vundle#begin()

" Plugin 'L9' " Example of loading a plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'gmarik/Vundle.vim'
Plugin 'https://github.com/vim-scripts/ZoomWin.git'
Plugin 'https://github.com/scrooloose/nerdtree.git'
Plugin 'https://github.com/ervandew/supertab.git'
Plugin 'https://github.com/Shougo/unite.vim.git'
Plugin 'https://github.com/kchmck/vim-coffee-script.git'
Plugin 'https://github.com/tpope/vim-commentary.git'
Plugin 'https://github.com/tpope/vim-cucumber.git'
Plugin 'https://github.com/elixir-lang/vim-elixir.git'
Plugin 'https://github.com/tpope/vim-endwise.git'
Plugin 'https://github.com/dag/vim-fish.git'
Plugin 'https://github.com/tpope/vim-fugitive.git'
Plugin 'https://github.com/tpope/vim-haml.git'
Plugin 'https://github.com/bitc/hdevtools.git'
Plugin 'https://github.com/pangloss/vim-javascript.git'
Plugin 'https://github.com/mxw/vim-jsx' " react.js
Plugin 'https://github.com/tpope/vim-markdown.git'
Plugin 'https://github.com/bling/vim-airline'
Plugin 'https://github.com/tpope/vim-repeat.git'
Plugin 'https://github.com/skwp/vim-rspec.git'
Plugin 'https://github.com/vim-ruby/vim-ruby.git'
Plugin 'https://github.com/tpope/vim-surround.git'
Plugin 'https://github.com/nelstrom/vim-textobj-rubyblock.git'
Plugin 'https://github.com/kana/vim-textobj-user.git'
Plugin 'https://github.com/fatih/vim-go.git'
Plugin 'https://github.com/jdonaldson/vaxe.git'
Plugin 'https://github.com/wting/rust.vim'
Plugin 'https://github.com/jneen/ragel.vim'
Plugin 'https://github.com/chrisbra/csv.vim'

" theme options
Plugin 'https://github.com/mkarmona/colorsbox'
Plugin 'https://github.com/morhetz/gruvbox'
Plugin 'https://github.com/w0ng/vim-hybrid'
Plugin 'https://github.com/vim-scripts/darktango.vim'
Plugin 'https://github.com/ciaranm/inkpot'
Plugin 'https://github.com/sickill/vim-monokai'
Plugin 'https://github.com/gosukiwi/vim-atom-dark'


call vundle#end()            " required
filetype plugin indent on    " required


set encoding=utf-8

"" Configure Plugins
set laststatus=2                                        " Always show the statusline

let g:airline#extensions#disable_rtp_load = 1           " don't autoload extensions
let g:airline_powerline_fonts             = 0           " no fancy separator charactors
let g:airline_left_sep                    = ''          " no fancy separator on LHS
let g:airline_right_sep                   = ''          " no fancy separator on RHS
let g:airline#extensions#branch#enabled   = 0           " don't show git branch
let g:airline_detect_modified             = 1           " marks when the file has changed
let g:airline_detect_paste                = 1           " enable paste detection (set paste) ie I'm not typing, I'm pasting, dammit, vim!
let g:airline_detect_iminsert             = 1           " I have no idea
let g:airline_inactive_collapse           = 1           " inactive windows should have the left section collapsed to only the filename of that buffer.
let g:airline_section_y                   = ''          " turn off file encoding
let g:airline_theme                       = 'bubblegum' " https://github.com/bling/vim-airline/wiki/Screenshots#bubblegum
" let g:airline_solarized_bg                = 'dark'
" let g:airline_theme                       = 'solarized'
" let g:airline_theme                       = 'molokai'
" let g:airline_theme                       = 'sol'


let g:csv_highlight_column = 'y'

runtime macros/matchit.vim  " vim-textobj-rubyblock

" open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" close vim if NERDTree is the only open buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Now switch to this custom colorscheme (dark gray)
colorscheme gruvbox " slightly brighter than 'hybrid' theme
map <silent><F3> :NEXTCOLOR<cr>
map <silent><F2> :PREVCOLOR<cr>

"" Seeing Is Believing
nmap <leader>b :%!seeing_is_believing --timeout 12 --line-length 500 --number-of-captures 300 --alignment-strategy chunk<CR>
nmap <leader>n :%!seeing_is_believing --timeout 12 --line-length 500 --number-of-captures 300 --alignment-strategy chunk --xmpfilter-style<CR>
nmap <leader>c :%!seeing_is_believing --clean<CR>
nmap <leader>m A # => <Esc>
vmap <leader>m :norm A # => <Esc>

"" Use "." to repeat the macro in "q" (uses repeat.vim)
nmap <Plug>RunRegq @q<CR>
nmap <Leader>q :call repeat#set("\<Plug>RunRegq")<CR>

"" Basic editor behaviour
filetype plugin indent on       " load file type plugins + indentation
syntax on                   " highlighting and shit
set cursorline                  " colours the line the cursor is on
set scrolloff=4                 " adds top/bottom buffer between cursor and window
set number                      " line numbers
set showcmd                     " display incomplete commands
set autoread                    " Auto-reload buffers when file changed on disk
set background=dark             " Tell vim the theme is dark (so it picks smarter colour defaults)

"" Whitespace
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()  " strip trailing whitespace on save
set nowrap                                                   " don't wrap lines
set tabstop=2 shiftwidth=2                                   " a tab is two spaces (or set this to 4)
set expandtab                                                " use spaces, not tabs (optional)
set backspace=indent,eol,start                               " backspace through everything in insert mode

"" Searching
set hlsearch  " highlight matches
set incsearch " incremental searching

"" Omg, vim, Imma edit the same file multiple times, okay? fkn deal with it
set nobackup                             " no backup files
set nowritebackup                        " don't backup file while editing
set noswapfile                           " don't create swapfiles for new buffers
set updatecount=0                        " Don't try to write swapfiles after some number of updates
set backupskip=/tmp/*,/private/tmp/*    " can edit crontab files

"" Convenience
nmap <Leader>p orequire "pry"<CR>binding.pry<ESC>;        " pry insertion
vnoremap . :norm.<CR>;                                    " in visual mode, "." will for each line, go into normal mode and execute the "."
nnoremap <Leader>w :w!<CR>;                               " Fuck you x1million, vim (http://stackoverflow.com/questions/26070153/vim-wont-write-file-without-a-sometimes-e13)
nnoremap <Leader>v :set paste<CR>"*p<CR>:set nopaste<CR>; " paste without being stupid ("*p means to paste on next line (p) from the register (") that represents the clipboard (*))

" replaces %/ with current directory, and %% with current file
cmap %/ <C-R>=expand("%:p:h")."/"<CR>
cmap %% <C-R>=expand("%")<CR>

"" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

"" Emacs/Readline keybindings for commandline mode
"  http://tiswww.case.edu/php/chet/readline/readline.html#SEC4
"  many of these taken from vimacs http://www.vim.org/scripts/script.php?script_id=300
" navigation
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <Esc>b <S-Left> " commenting out b/c makes it pause
cnoremap <Esc>f <S-Right>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>
" editing
cnoremap <M-p> <Up>
cnoremap <M-n> <Down>
cnoremap <C-k> <C-f>d$<C-c><End>
cnoremap <C-y> <C-r><C-o>"
cnoremap <C-d> <Right><C-h>

"" filetypes
au BufRead,BufNewFile *.elm setfiletype haskell
au BufRead,BufNewFile *.sublime-* setfiletype javascript " .sublime-{settings,keymap,menu,commands}
au BufRead,BufNewFile *.sublime-snippet setfiletype html
au BufRead,BufNewFile *.rl setfiletype ragel

" Profiling, taken from https://github.com/bling/minivimrc
nnoremap <silent> <leader>DD :exe ":profile start profile.log"<cr>:exe ":profile func *"<cr>:exe ":profile file *"<cr>
nnoremap <silent> <leader>DP :exe ":profile pause"<cr>
nnoremap <silent> <leader>DC :exe ":profile continue"<cr>
nnoremap <silent> <leader>DQ :exe ":profile pause"<cr>:noautocmd qall!<cr>

"" Maybe worth checking out
" Profiling plugins
"   https://github.com/bling/minivimrc/blob/43d099cc351424c345da0224da83c73b75bce931/vimrc#L30
" Ctrl-P
"   https://github.com/kien/ctrlp.vim
" Unite.vim
"   https://github.com/Shougo/unite.vim
" Vim airline integrations
"   https://github.com/bling/vim-airline
"   vim-bufferline, fugitive, unite, ctrlp, minibufexpl, gundo, undotree, nerdtree, tagbar, vim-gitgutter, vim-signify, syntastic, eclim, lawrencium, virtualenv, tmuxline.
" marks
"   http://vim.wikia.com/wiki/Using_marks
" vim tree indentation
"   http://vim.wikia.com/wiki/Using_Vim_as_an_outline_processor
"   http://www.vim.org/scripts/script.php?script_id=1266
"   http://vim.wikia.com/wiki/Indenting_source_code
"   http://vim.wikia.com/wiki/Folding_for_plain_text_files_based_on_indentation
"   http://superuser.com/questions/131950/indentation-for-plain-text-bulleted-lists-in-vim
"   http://lucasoman.blogspot.com/2010/12/list-file-plugin-for-vim.html
"   http://www.vim.org/scripts/script.php?script_id=3368
"   https://github.com/vim-scripts/tree/blob/master/doc/tree.txt
"   http://vim.wikia.com/wiki/Folding_for_plain_text_files_based_on_indentation
