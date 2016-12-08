" ===== Declare Dependencies To Vundle =====
" Vundle needs to be before everything else, IDK why.
" Plugin configuration is at the bottom of the file
"
" :VundleInstall        - Installs any missing pulugins
" :VundleClean          - Remove unused plugins
" :VundleSearch ZoomWin - searches vimscripts for ZoomWin

set nocompatible                  " Behave more usefully at the expense of backwards compatibility (this line comes first b/c it alters how the others work)
filetype off                      " Don't run filetype callbacks while Vundle does its thing
set rtp+=~/.vim/bundle/Vundle.vim " Set the runtime path to include Vundle
call vundle#begin()               " Initialize Vundle

" Useful
Plugin 'https://github.com/gmarik/Vundle.vim'               " Let Vundle manage itself
Plugin 'https://github.com/scrooloose/nerdtree'             " Tree Display for the file system
Plugin 'https://github.com/ervandew/supertab'               " Mediocre tab completion, still haven't seen anything approach TextMate1
Plugin 'https://github.com/Shougo/vimproc.vim'              " Runs tasks Asynchronously, it's a dependency of Unite.vim
Plugin 'https://github.com/Shougo/unite.vim'                " Searches through lists of things (files, buffers, etc)
Plugin 'https://github.com/tpope/vim-commentary'            " Easily comment/uncomment code
Plugin 'https://github.com/tpope/vim-endwise'               " Automatically inserts `end` for you. Convenient, works well, stays out of the way otherwise
Plugin 'https://github.com/tpope/vim-fugitive'              " Git integration... I should learn this better
Plugin 'https://github.com/bling/vim-airline'               " Status bar at the bottom of the screen
Plugin 'https://github.com/tpope/vim-repeat'                " Uhm, a dep of something, it lets you repeat non-atomic instructions with the dot. Unfortunately, too minimal, so not easy for me to use (I wish it would take over vim's shitty macro system)
Plugin 'https://github.com/tpope/vim-surround'              " Better support for working with things that 'surround' text such as quotes and parens
Plugin 'https://github.com/rking/ag.vim'                    " Searches through your project
Plugin 'https://github.com/majutsushi/tagbar'               " Ctag browser

" Language Support
Plugin 'https://github.com/vim-ruby/vim-ruby'               " Ruby    - Pretty fkn legit (eg it's generally $LOAD_PATH aware, it's got some really awesome text objects)
Plugin 'https://github.com/tpope/vim-cucumber'              " Gherkin - Cucumber's DSL (Given / When / Then)

Plugin 'https://github.com/pangloss/vim-javascript'         " JavaScript     - The humans have turned this language into something to respect
Plugin 'https://github.com/kchmck/vim-coffee-script'        " CoffeeScript   - Syntactically, this is the language I always want to write, improved a lot of things from JavaScript, which they've largely incorporated in ES6
Plugin 'https://github.com/mxw/vim-jsx'                     " JSX (React.js) - Lets you write 'html' within your JavaScript

Plugin 'https://github.com/bitc/hdevtools'                  " Haskell - This is the language that caused me to realize that choice and time are abstractions
Plugin 'https://github.com/lambdatoast/elm.vim'             " Elm     - Haskell in the browser (a super approachable functional language)
Plugin 'https://github.com/elixir-lang/vim-elixir'          " Elixir  - My brain summarizes it as 'Erlang with Ruby syntax', but that's probably selling it short
Plugin 'https://github.com/wting/rust.vim'                  " Rust    - Hopefully one day this will replace C
Plugin 'https://github.com/fatih/vim-go'                    " Go      - Forgot why I didn't keep playing with it,
Plugin 'https://github.com/jdonaldson/vaxe'                 " Haxe    - Compiles to other languages, mostly used by game devs

Plugin 'https://github.com/tpope/vim-markdown'              " Markdown - A plain text format for barely structured documents
Plugin 'https://github.com/tpope/vim-haml'                  " Haml     - A better HTML
Plugin 'https://github.com/jneen/ragel.vim'                 " Ragel    - State machine / parser language
Plugin 'https://github.com/chrisbra/csv.vim'                " CSV      - a few nice features, some obvious ones missing
Plugin 'https://github.com/dag/vim-fish'                    " Fish     - alternate shell
Plugin 'https://github.com/keith/swift.vim'                 " Swift    - Apple's replacement for Objective-C

" Colorschemes (syntax highlighting, aka themes)
Plugin 'https://github.com/morhetz/gruvbox'
Plugin 'https://github.com/mkarmona/colorsbox'
Plugin 'https://github.com/w0ng/vim-hybrid'
Plugin 'https://github.com/vim-scripts/darktango.vim'
Plugin 'https://github.com/ciaranm/inkpot'
Plugin 'https://github.com/sickill/vim-monokai'
Plugin 'https://github.com/gosukiwi/vim-atom-dark'
Plugin 'https://github.com/vim-airline/vim-airline-themes'

call vundle#end()            " required


" ===== Smallest Viable Configuration =====
set nocompatible                     " Behave more usefully at the expense of backwards compatibility (this line comes first b/c it alters how the others work)
set encoding=utf-8                   " Format of the text in our files (prob not necessary, but should prevent weird errors)
filetype plugin on                   " Load code that configures vim to work better with whatever we're editing
filetype indent on                   " Load code that lets vim know when to indent our cursor
syntax on                            " Turn on syntax highlighting
set backspace=indent,eol,start       " backspace through everything in insert mode
set expandtab                        " When I press tab, insert spaces instead
set shiftwidth=2                     " Specifically, insert 2 spaces
set tabstop=2                        " When displaying tabs already in the file, display them with a width of 2 spaces

" ===== Instead of backing up files, just reload the buffer when it changes. =====
" The buffer is an in-memory representation of a file, it's what you edit
set autoread                         " Auto-reload buffers when file changed on disk
set nobackup                         " Don't use backup files
set nowritebackup                    " Don't backup the file while editing
set noswapfile                       " Don't create swapfiles for new buffers
set updatecount=0                    " Don't try to write swapfiles after some number of updates
set backupskip=/tmp/*,/private/tmp/* " Let me edit crontab files

" ===== Aesthetics =====
set t_Co=256                         " Explicitly tell vim that the terminal supports 256 colors (iTerm2 does, )
set background=dark                  " Tell vim to use colours that works with a dark terminal background (opposite is 'light')
set nowrap                           " Display long lines as truncated instead of wrapped onto the next line
set cursorline                       " Colour the line the cursor is on
set number                           " Show line numbers
set hlsearch                         " Highlight all search matches that are on the screen
set showcmd                          " Display info known about the command being edited (eg number of lines highlighted in visual mode)

" ===== Basic behaviour =====
set scrolloff=4                      " Scroll away from the cursor when I get too close to the edge of the screen
set incsearch                        " Incremental searching


" ===== Custom Language Settings =====
autocmd Filetype c    setlocal tabstop=8
autocmd Filetype cpp  setlocal tabstop=8
autocmd Filetype yacc setlocal tabstop=8

" ===== Mappings and keybindings =====
" Note that <Leader> is the backslash by default. You can change it, though, as seen here:
" https://github.com/bling/minivimrc/blob/43d099cc351424c345da0224da83c73b75bce931/vimrc#L20-L21

" Replace %/ with directory of current file (eg `:vs %/`)
  cmap %/ <C-R>=expand("%:p:h")."/"<CR>
" Replace %% with current file (eg `:vs %%`)
  cmap %% <C-R>=expand("%")<CR>
" In visual mode, "." will for each line, go into normal mode and execute the "."
  vnoremap . :norm.<CR>
" Paste without being stupid ("*p means to paste on next line (p) from the register (") that represents the clipboard (*))
  nnoremap <Leader>v :set paste<CR>"*p<CR>:set nopaste<CR>
" Pry insertion
  nmap <Leader>p orequire "pry"<CR>binding.pry<ESC>

" ===== Seeing Is Believing =====
" Assumes you have a Ruby with SiB available in the PATH
" If it doesn't work, you may need to `gem install seeing_is_believing -v 3.0.0.beta.6`
" ...yeah, current release is a beta, which won't auto-install

" Annotate every line
  nmap <leader>b :%!seeing_is_believing --timeout 12 --line-length 500 --number-of-captures 300 --alignment-strategy chunk<CR>;
" Annotate marked lines
  nmap <leader>n :%.!seeing_is_believing --timeout 12 --line-length 500 --number-of-captures 300 --alignment-strategy chunk --xmpfilter-style<CR>;
" Remove annotations
  nmap <leader>c :%.!seeing_is_believing --clean<CR>;
" Mark the current line for annotation
  nmap <leader>m A # => <Esc>
" Mark the highlighted lines for annotation
  vmap <leader>m :norm A # => <Esc>

" ===== Window Navigation ======
" Move to window below me
  nnoremap <c-j> <c-w>j
" Move to window above me
  nnoremap <c-k> <c-w>k
" Move to window left of me
  nnoremap <c-h> <c-w>h
" Move to window right of me
  nnoremap <c-l> <c-w>l

" left / shift-left decreases width
  nmap <Left>    :wincmd <<CR>
  nmap <S-Left>  :5wincmd <<CR>
" right / shift-left increases width
  nmap <Right>   :wincmd ><CR>
  nmap <S-Right> :5wincmd ><CR>
" up / shift-left increases height
  nmap <Up>      :wincmd +<CR>
  nmap <S-Up>    :5wincmd +<CR>
" down / shift-left decreases height
  nmap <Down>    :wincmd -<CR>
  nmap <S-Down>  :5wincmd -<CR>


" ===== Emacs/Readline Keybindings For Commandline Mode =====
" http://tiswww.case.edu/php/chet/readline/readline.html#SEC4
" many of these taken from vimacs http://www.vim.org/scripts/script.php?script_id=300

" Navigation
  " Beginning of line
  cnoremap <C-a> <Home>
  " End of line
  cnoremap <C-e> <End>
  " Right 1 character
  cnoremap <C-f> <Right>
  " Left 1 character
  cnoremap <C-b> <Left>
  " Left 1 word
  cnoremap <M-b> <S-Left>
  " Right 1 word
  cnoremap <M-f> <S-Right>

" Editing
  " Previous command
  cnoremap <M-p> <Up>
  " Next command (after you've gone to previous)
  cnoremap <M-n> <Down>
  " Cut to end of line
  cnoremap <C-k> <C-f>d$<C-c><End>
  " Paste
  cnoremap <C-y> <C-r><C-o>"
  " Delete character to the right
  cnoremap <C-d> <Right><C-h>

" =====  Profiling  =====
" Taken from https://github.com/bling/minivimrc I haven't tried them yet
nnoremap <silent> <leader>DD :exe ":profile start profile.log"<cr>:exe ":profile func *"<cr>:exe ":profile file *"<cr>
nnoremap <silent> <leader>DP :exe ":profile pause"<cr>
nnoremap <silent> <leader>DC :exe ":profile continue"<cr>
nnoremap <silent> <leader>DQ :exe ":profile pause"<cr>:noautocmd qall!<cr>

"" ===== Whitespace =====
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

" ===== Filetypes =====
au BufRead,BufNewFile *.sublime-* setfiletype javascript " .sublime-{settings,keymap,menu,commands}
au BufRead,BufNewFile *.sublime-snippet setfiletype html
au BufRead,BufNewFile *.ipynb setfiletype json
au BufRead,BufNewFile *.rl setfiletype ragel
au BufRead,BufNewFile *.es6 setfiletype javascript.jsx
au BufRead,BufNewFile *.ik setfiletype ruby " it's wong (this is ioke) but better than totally unhighlighted


" ==========================================================================================================
"                                         Configure Plugins
" ==========================================================================================================


" ===== Airline =====
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


" ===== CSV =====
let g:csv_highlight_column = 'y'


" ===== vim-textobj-rubyblock =====
" Not sure what it does
runtime macros/matchit.vim


" ===== NERDTree =====

" Open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Close vim if NERDTree is the only open buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

nmap <C-N> :NERDTreeToggle<CR>


" ===== Gruvbox for the Colorscheme =====
" Now switch to this custom colorscheme (dark gray)
" 'gruvbox', 'hybrid', and 'solarized' dark theme are my favs
" can't use solarized, though, b/c it throws students off since there's not a
" super obvious visual transition between my shell and my editor.
"
" So, choosing between gruvbox and hybrid. gruvbox has less contrat, hybrid is darker
colorscheme hybrid
map <silent><F3> :NEXTCOLOR<cr>
map <silent><F2> :PREVCOLOR<cr>


" ===== Repeat.vim =====
" Use "." to repeat the macro in "q"
" Really, wish I could just use q to start/stop a macro, and then have the
" last macro recorded or run be auto-loaded for repeat
nmap <Plug>RunRegq @q<CR>:call repeat#set("\<Plug>RunRegq")<CR>
nmap <Leader>q :call repeat#set("\<Plug>RunRegq")<CR>




"" Maybe worth checking out
" Ctrl-P
"   https://github.com/kien/ctrlp.vim
" Vim airline integrations
"   https://github.com/bling/vim-airline
"   vim-bufferline, fugitive, unite, ctrlp, minibufexpl, gundo, undotree, nerdtree, tagbar, vim-gitgutter, vim-signify, syntastic, eclim, lawrencium, virtualenv, tmuxline.
" marks
"   http://vim.wikia.com/wiki/Using_marks
" sneak
"   https://github.com/justinmk/vim-sneak
" file nav
"   https://github.com/Shougo/vimfiler.vim
" Unite
"   https://github.com/Shougo/unite.vim
"   http://bling.github.io/blog/2013/06/02/unite-dot-vim-the-plugin-you-didnt-know-you-need/
"   http://www.codeography.com/2013/06/17/replacing-all-the-things-with-unite-vim.html
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
