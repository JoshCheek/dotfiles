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
           code                    $HOME/code
           life                    $HOME/code/life

           ruby                    $HOME/deleteme/ruby
           rails                   $HOME/deleteme/rails
           activemodel             $HOME/deleteme/rails/activemodel
           activesupport           $HOME/deleteme/rails/activesupport
           activerecord            $HOME/deleteme/rails/activerecord

           work                    $HOME/code/jsl
           work/apply              $HOME/code/jsl/apply
           work/enroll             $HOME/code/jsl/enroll

           dotfiles                $HOME/code/dotfiles
           dotfiles/bin            $HOME/code/dotfiles/bin
           dotfiles/fish           $HOME/code/dotfiles/fish
           dotfiles/fish/functions $HOME/code/dotfiles/fish

           Dropbox                 $HOME/Dropbox
           Desktop                 $HOME/Desktop
         "


   set -u help_screen \
    "
    $program_name [flag | diralias]

      CD to dirs I care about

      Flags:
        -l, --list     # list directory aliases
        -h, --help     # this screen
        --completions  # print fish completions
        --edit         # edit this script

      diralias:
        one of the aliases on the left
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
    echo $help_screen | tidy_text --sub '/^ {,4}/' ''
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

    echo $help_screen | sed -E -n '
      # keep lines between flags and the table header for diraliases
      /^[[:space:]]*Flags:$/,/^[=[:space:]]+$/ !d

      # keep lines with dashes
      /-.*#/ !d

      # save current line in hold space
      h

      # print short flag completions (going with "old" instead b/c they look the same, but don\'t get combined
      /.*[^-]-([[:alnum:]])[^[:alnum:]][^#]*#[[:space:]]*(.*)$/ {
        s//-c '$program_name' --old-option \1 -d "\2" --no-files/p
      }

      # load hold space into pattern space
      g

      # print long flag completions
      /.*[^-]--([[:alnum:]]+)[^#]*#[[:space:]]*(.*)$/ {
        s//-c '$program_name' --long-option \1 -d "\2" --no-files/p
      }
    ' # I CONQUERED YOU, SED!


  else if test -n $edit_this_script
    vim (status -f)

  else if test -n "$diraliases"
    set directory (echo $definitions | alias-to-directory $diraliases ^/dev/null)
    and echo cd $directory
    and cd $directory
  end
end
