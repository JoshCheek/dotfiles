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
           code         $HOME/code
           cln          $HOME/code/cln
           deject       $HOME/code/deject
           haiti        $HOME/code/haiti
           rks          $HOME/code/ruby-kickstart
           sib          $HOME/code/seeing_is_believing
           blogs        $HOME/code/source-blogs
           words        $HOME/code/words

           df           $HOME/code/dotfiles
           dfb          $HOME/code/dotfiles/bin

           atom         $HOME/ref/tools/atom
           mri          $HOME/ref/ruby/mri
           rbx          $HOME/ref/ruby/rubinius
           jruby        $HOME/ref/ruby/jruby
           rails        $HOME/ref/ruby/rails
           rails-am     $HOME/ref/ruby/rails/activemodel
           rails-as     $HOME/ref/ruby/rails/activesupport
           rails-ar     $HOME/ref/ruby/rails/activerecord
           homebrew     $HOME/ref/tools/homebrew
           fish         $HOME/ref/tools/fish-shell
           v8           $HOME/ref/javascript/v8

           jsl          $HOME/code/jsl
           apply        $HOME/code/jsl/apply
           today        $HOME/code/jsl/today
           enroll       $HOME/code/jsl/enroll
           assessments  $HOME/code/jsl/student-assessments

           life         $HOME/code/life
           cliffnote    $HOME/code/life/cliffnote-learning
           Dropbox      $HOME/Dropbox
           Desktop      $HOME/Desktop
           deleteme     $HOME/deleteme
         "


   set -u help_screen \
    "
    $program_name [flag | diralias]

      CD to dirs I care about

      Flags:
        -l, --list     # list directory aliases
        -h, --help     # this screen
        --edit         # edit this script

      diralias:
        one of the aliases on the left
    "

  set print_help        ''
  set print_list        ''
  set edit_this_script  ''
  set diraliases
  for arg in $argv
    switch $arg
      case -h --help
        set print_help true
      case -l --list
        set print_list true
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

  else if test -n $edit_this_script
    vim (status -f)

  else if test -n "$diraliases"
    set directory (echo $definitions | alias-to-directory $diraliases 2>/dev/null)
    and echo cd $directory
    and cd $directory
  end
end
