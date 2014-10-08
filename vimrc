set rtp+=/usr/local/go/misc/vim
filetype plugin indent on
syntax on

"" ==========  These come from Mislav (http://mislav.uniqpath.com/2011/12/vim-revisited/)  ==========
set nocompatible                " choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching

"" ==========  Pathogen, vim path manager (https://github.com/tpope/vim-pathogen#readme)  ==========
call pathogen#infect()

"" ==========  Powerline, toolbar (https://github.com/Lokaltog/vim-powerline/) ==========
let g:Powerline_symbols = 'compatible'
let g:Powerline_stl_path_style = 'relative'
set laststatus=2   " Always show the statusline
set t_Co=256       " Explicitly tell vim that the terminal supports 256 colors

" got this list from here: https://github.com/Lokaltog/vim-powerline/blob/c4b72c5be57b165bb6a89d0b8a974fe62c0091d0/autoload/Powerline/Themes/default.vim
call Pl#Theme#RemoveSegment('fugitive:branch')
call Pl#Theme#RemoveSegment('syntastic:errors')
call Pl#Theme#RemoveSegment('fileformat')
call Pl#Theme#RemoveSegment('fileencoding')
call Pl#Theme#RemoveSegment('filetype')
call Pl#Theme#RemoveSegment('lineinfo')

"" ========== NERDTree  ==========
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif " close vim if NERDTree is the only open buffer

"" ========== vim-textobj-rubyblock ==========
runtime macros/matchit.vim " a dependency

"" ==========  My shit  ==========
set nobackup                                        " no backup files
set nowritebackup                                   " only in case you don't want a backup file while editing
set noswapfile                                      " no swap files
set scrolloff=4                                     " adds top/bottom buffer between cursor and window
set cursorline                                      " colours the line the cursor is on
set number                                          " line numbers
nmap <Leader>p orequire "pry"<CR>binding.pry<ESC>;  " pry insertion
vnoremap . :norm.<CR>                               " in visual mode, "." will for each line, go into normal mode and execute the "."
set pastetoggle=<Leader>v

" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Emacs/Readline keybindings for commandline mode
" http://tiswww.case.edu/php/chet/readline/readline.html#SEC4
" many of these taken from vimacs http://www.vim.org/scripts/script.php?script_id=300
"
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


"" strip trailing whitespace
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
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" replaces %/ with current directory, and %% with current file
cmap %/ <C-R>=expand("%:p:h")."/"<CR>
cmap %% <C-R>=expand("%")<CR>

"" filetypes
au  BufRead,BufNewFile *.elm setfiletype haskell

" ========== Pathogen plugins ==========
"
" ZoomWin                     https://github.com/vim-scripts/ZoomWin.git
" nerdtree                    https://github.com/scrooloose/nerdtree.git
" supertab                    https://github.com/ervandew/supertab.git
" unite.vim                   https://github.com/Shougo/unite.vim.git
" vim-coffee-script           https://github.com/kchmck/vim-coffee-script.git
" vim-commentary              https://github.com/tpope/vim-commentary.git
" vim-cucumber                https://github.com/tpope/vim-cucumber.git
" vim-elixir                  https://github.com/elixir-lang/vim-elixir.git
" vim-endwise                 https://github.com/tpope/vim-endwise.git
" vim-fish                    https://github.com/dag/vim-fish.git
" vim-fugitive                https://github.com/tpope/vim-fugitive.git
" vim-haml                    https://github.com/tpope/vim-haml.git
" hdevtools                   https://github.com/bitc/hdevtools.git
" vim-javascript              https://github.com/pangloss/vim-javascript.git
" vim-markdown                https://github.com/tpope/vim-markdown.git
" vim-powerline               https://github.com/Lokaltog/vim-powerline.git
" vim-repeat                  https://github.com/tpope/vim-repeat.git
" vim-rspec                   https://github.com/skwp/vim-rspec.git
" vim-ruby                    https://github.com/vim-ruby/vim-ruby.git
" vim-surround                https://github.com/tpope/vim-surround.git
" vim-textobj-rubyblock       https://github.com/nelstrom/vim-textobj-rubyblock.git
" vim-textobj-user            https://github.com/kana/vim-textobj-user.git
