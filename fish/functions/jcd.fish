# really, I think this should be alias-to-cd
# called by jcd
# and alias-to-cd is really just a super-verbose
# implementation of Array#assoc -.^
function jcd --description "Josh's cd"
  set program_name jcd # inject this

  # dirh, dirs <-- might be interesting stuffs that would be worth adding?

  set -u definitions (tidy_text --strip           \
                                --remove-blank    \
                                --gsub '/ +/' ' ' \
                                "
                                  c  $HOME/code
                                  l  $HOME/code/life
                                  w  $HOME/code/jsl

                                  d  $HOME/code/dotfiles
                                  db $HOME/code/dotfiles/bin
                                  df $HOME/code/dotfiles/fish

                                  D  $HOME/Dropbox
                                ")

  set show_help        ''
  set show_list        ''
  set show_completions ''
  for arg in $argv
    switch $arg
      case '-h' '--help'
        set show_help true
      case '-l' '--list'
        set show_list true
      case '--completions'
        set show_completions true
      case '*'
        set diraliases $arg $diraliases
    end
  end

  if test -n $show_help
    echo $program_name' [flag | diralias]'
    echo ''
    echo '  CD to dirs I care about'
    echo ''
    echo '  Flags:'
    echo '    -l, --list  # list directory aliases'
    echo '    -h, --help  # this screen'
    echo ''
    echo '  diralias:'
    echo '    one of the aliases on the left'
    echo ''
    echo alias directory \n \
         ===== ========= \n \
         $dirs              | column -t | sed 's/^/    /'

  else if test -n $show_list
    echo $dirs | column -t

  else if test -n $show_completions
    for definition in $dirs
      echo $definition | read diralias dir
      echo -c $program_name --no-files -a $diralias -d $dir
    end

  else if test -n $directory
    set directory (echo $dirs | alias-to-directory $diraliases ^/dev/null)
    and echo cd $directory
    and cd $directory
  end
end

