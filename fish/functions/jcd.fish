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
           code                                                               $HOME/code
           code/PresentationFiles                                             $HOME/code/PresentationFiles
           code/bindable_block                                                $HOME/code/bindable_block
           code/cln                                                           $HOME/code/cln
           code/command_line_launcher                                         $HOME/code/command_line_launcher
           code/deject                                                        $HOME/code/deject
           code/drinking-with-josh-on-march-14                                $HOME/code/drinking-with-josh-on-march-14
           code/ghost_in_the_machine                                          $HOME/code/ghost_in_the_machine
           code/haiti                                                         $HOME/code/haiti
           code/joshcheek                                                     $HOME/code/joshcheek
           code/keyboard_magician                                             $HOME/code/keyboard_magician
           code/letter_press_is_not_as_good_as_boggle                         $HOME/code/letter_press_is_not_as_good_as_boggle
           code/ruby-kickstart                                                $HOME/code/ruby-kickstart
           code/rubytags                                                      $HOME/code/rubytags
           code/seeing_is_believing                                           $HOME/code/seeing_is_believing
           code/she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist $HOME/code/she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist
           code/source-blogs                                                  $HOME/code/source-blogs
           code/surrogate                                                     $HOME/code/surrogate
           code/tetris                                                        $HOME/code/tetris
           code/text_indentation_to_tree                                      $HOME/code/text_indentation_to_tree
           code/todo-game                                                     $HOME/code/todo-game
           code/under_the_hood                                                $HOME/code/under_the_hood
           code/view_ruby_regexes                                             $HOME/code/view_ruby_regexes
           code/words                                                         $HOME/code/words


           dotfiles                 $HOME/code/dotfiles
           dotfiles/bin             $HOME/code/dotfiles/bin
           dotfiles/fish            $HOME/code/dotfiles/fish
           dotfiles/fish/functions  $HOME/code/dotfiles/fish

           ruby                     $HOME/deleteme/ruby
           rubinius                 $HOME/deleteme/rubinius
           rails                    $HOME/deleteme/rails
           activemodel              $HOME/deleteme/rails/activemodel
           activesupport            $HOME/deleteme/rails/activesupport
           activerecord             $HOME/deleteme/rails/activerecord

           work                     $HOME/code/jsl
           work/apply               $HOME/code/jsl/apply
           work/today               $HOME/code/jsl/today
           work/enroll              $HOME/code/jsl/enroll
           work/curriculum          $HOME/code/jsl/curriculum
           work/standard            $HOME/code/jsl/standard
           work/student-assessments $HOME/code/jsl/student-assessments

           life                     $HOME/code/life
           Dropbox                  $HOME/Dropbox
           Desktop                  $HOME/Desktop
           deleteme                 $HOME/deleteme
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
