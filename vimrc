"" Vundle (needs to be before everything else)
" see :h vundle for more details or wiki for FAQ
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

set nocompatible                  " don't try to be compatible with legacy vi
filetype off
set rtp+=~/.vim/bundle/Vundle.vim " set the runtime path to include Vundle and initialize
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
Plugin 'https://github.com/tpope/vim-markdown.git'
Plugin 'https://github.com/Lokaltog/vim-powerline.git'
Plugin 'https://github.com/tpope/vim-repeat.git'
Plugin 'https://github.com/skwp/vim-rspec.git'
Plugin 'https://github.com/vim-ruby/vim-ruby.git'
Plugin 'https://github.com/tpope/vim-surround.git'
Plugin 'https://github.com/nelstrom/vim-textobj-rubyblock.git'
Plugin 'https://github.com/kana/vim-textobj-user.git'
Plugin 'https://github.com/fatih/vim-go.git'
Plugin 'https://github.com/jdonaldson/vaxe.git'

call vundle#end()            " required
filetype plugin indent on    " required


set encoding=utf-8

"" Plugins powerline, nerdtree, vim-textobj-rubyblock, selecta
set laststatus=2                                 " Always show the statusline
let g:Powerline_symbols = 'compatible'
let g:Powerline_stl_path_style = 'relative'
call Pl#Theme#RemoveSegment('fugitive:branch')   " turn off all the extra stuff
call Pl#Theme#RemoveSegment('syntastic:errors')  " https://github.com/Lokaltog/vim-powerline/blob/c4b72c5be57b165bb6a89d0b8a974fe62c0091d0/autoload/Powerline/Themes/default.vim
call Pl#Theme#RemoveSegment('fileformat')
call Pl#Theme#RemoveSegment('filetype')
call Pl#Theme#RemoveSegment('lineinfo')
call Pl#Theme#RemoveSegment('fileencoding')

runtime macros/matchit.vim                       " vim-textobj-rubyblock

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif " close vim if NERDTree is the only open buffer

"" Basic editor behaviour
filetype plugin indent on       " load file type plugins + indentation
set t_Co=256                    " Explicitly tell vim that the terminal supports 256 colors
syntax enable                   " highlighting and shit
set cursorline                  " colours the line the cursor is on
set scrolloff=4                 " adds top/bottom buffer between cursor and window
set number                      " line numbers
set showcmd                     " display incomplete commands
set autoread                    " Auto-reload buffers when file changed on disk

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
set hlsearch                    " highlight matches
set incsearch                   " incremental searching

"" Omg, vim, Imma edit the same file multiple times, okay? fkn deal with it
set nobackup                             " no backup files
set nowritebackup                        " don't backup file while editing
set noswapfile                           " don't create swapfiles for new buffers
set updatecount=0                        " Don't try to write swapfiles after some number of updates
set backupskip=/tmp/*,/private/tmp/*"    " can edit crontab files

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
au  BufRead,BufNewFile *.elm setfiletype haskell

