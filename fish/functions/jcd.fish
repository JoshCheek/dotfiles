# really, I think this should be alias-to-cd
# called by jcd
# and alias-to-cd is really just a super-verbose
# implementation of Array#assoc -.^
function jcd --description "Josh's cd"
  set program_name jcd # inject this

  # dirh, dirs <-- might be interesting stuffs that would be worth adding?

  # trying to get this variable set has been so fucking painful :(
  # Lets say there is a program with output that I want in a variable
  # e.g. (seq 3), so my var should have "1\n2\n3\n"... HOW DO I DO THAT?
  set -u definitions \
         "
           c  $HOME/code
           l  $HOME/code/life
           w  $HOME/code/jsl

           d  $HOME/code/dotfiles
           db $HOME/code/dotfiles/bin
           df $HOME/code/dotfiles/fish

           Dr $HOME/Dropbox
           De $HOME/Desktop
         "

  set print_help        ''
  set print_list        ''
  set print_completions ''
  set edit_this_script  ''
  set diraliases
  for arg in $argv
    switch $arg
      case -h --help
        set print_help true
      case -l --list
        set print_list true
      case --completions --completion
        set print_completions true
      case --edit
        set edit_this_script true
      case '*'
        set diraliases $arg $diraliases
    end
  end

  if test -n $print_help
    echo $program_name' [flag | diralias]'
    echo ''
    echo '  CD to dirs I care about'
    echo ''
    echo '  Flags:'
    echo '    -l, --list     # list directory aliases'
    echo '    -h, --help     # this screen'
    echo '    --completions  # print fish completions'
    echo '    --edit         # edit this script'
    echo ''
    echo '  diralias:'
    echo '    one of the aliases on the left'
    echo ''
    begin
      echo alias directory
      echo ===== =========
      echo $definitions
    end | column -t | sed 's/^/    /'

  else if test -n $print_list
    echo $definitions | column -t

  else if test -n $print_completions
    for definition in (tidy_text --gsub '/ +/' ' ' --strip --remove-blank $definitions)
      echo $definition | read diralias dir
      echo -c $program_name --no-files -a $diralias -d $dir
    end

  else if test -n $edit_this_script
    vim (status -f)

  else if test -n "$diraliases"
    set directory (echo $definitions | alias-to-directory $diraliases ^/dev/null)
    and echo cd $directory
    and cd $directory
  end
end
