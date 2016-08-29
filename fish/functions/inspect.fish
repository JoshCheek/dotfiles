# Add multi-dimensional inspection?
# Format output when it gets too long?

function inspect -d "Human readable representation of arguments"
  # default to coloured output if stdout is a shell
  set -l use_colour false
  if command test -t 1 # use `command` b/c of a bug https://github.com/fish-shell/fish-shell/issues/1228#issuecomment-243020104
    set use_colour true
  end

  set -l print_help false

  # parse args
  set -l to_inspect
  for arg in $argv
    switch $arg
    case -h --help
      set print_help true
    case -c --color --colour
      set use_colour true
    case -C --no-color --no-colour
      set use_colour false
    case \*
      set to_inspect $to_inspect $arg
    end
  end

  if [ $print_help = true ]
    echo 'Usage: inspect [flags] [$argname]'
    echo
    echo '  The purpose of the program is to show the values of variables'
    echo '  The output format is based off of other languages like Ruby and JavaScript'
    echo
    echo 'Options:'
    echo
    echo '  -h, --help      # Print this help screen'
    echo '  -c, --colour    # Colour the output'
    echo '  -C, --no-colour # Do not colour the output'
    echo
    echo 'Colour:'
    echo
    echo '  Syntax highlighting based off your fish theme.'
    echo '  Defaults to true when stdout is a tty and false otherwise'
  end

  _print_array $use_colour $to_inspect
  echo
end

function _print_array -a use_colour
  if [ 1 -lt (count $argv) ]
    set argv $argv[2..-1]
  end
  set -l index 1
  set -l last  (count $argv)
  set color_name $fish_color_param # alternatives: $fish_color_{command,operator,param,error}

  _colour $use_colour $color_name
  echo -n '['

  for arg in $argv
    _inspect_one $use_colour $arg
    if [ ! $index -eq $last ]
      _colour $use_colour $color_name
      echo -n ', '
    end
    set index (math 1 + $index)
  end

  _colour $use_colour $color_name
  echo -n ']'

  _colour $use_colour normal
end

function _colour -a use_colour color
  if [ true = $use_colour ]
    set_color $color
  end
end


function _inspect_one -a use_colour to_inspect
  # opening quote
  _colour $use_colour $fish_color_quote
  echo -n "'"

  set -l last_colour none
  string split '' $to_inspect \
  # escape them one char at a time so that we keep them grouped together and don\'t have to reparse it
  | string escape \
  # strip any quotes wrapping the char since we want to put them all together
  | sed -E 's/\'(.*)\'/\1/' \
  | while read -l escaped
      # Split is approximately this: `"a\nb".split.each { |c| print "#{c}\n" }`
      # Which would print "a\n\n\nb\n". So if we find an empty line, it was really a newline,
      # and we need to read the next line in too, as that was the newline's newline
      if [ -z $escaped ]
        read escaped
        set escaped '\n'
      end

      # Figure out which colour to use,
      # don't set the colour when it's already set
      # (an optimization since this is expensive)
      set -l current_colour (
        [ 1 = (string length $escaped) ]
        and echo -n $fish_color_quote
        or echo -n $fish_color_escape
      )
      if [ $last_colour != $current_colour ]
        set last_colour $current_colour
        _colour $use_colour $current_colour
      end

      # print the character
      echo -n $escaped
    end \
  | tr -d \n # remove newlines that got added by sed

  # closing quote
  _colour $use_colour $fish_color_quote
  echo -n "'"
end


# function _inspect_one -a use_colour to_inspect
#   if [ 0 = (string length $to_inspect) ]
#     _colour $use_colour $fish_color_quote
#     echo -n '""'
#   else
#     # We have to iterate over it in this manner because string split will print "\n\n" for a single newline, which comes in as two empty strings
#     set -l chars (string split '' $to_inspect)
#     set -l last  (count $chars)
#     set -l i     1
#     while [ $i -le $last ]
#       set -l char $chars[$i]
#       if [ "$char" = '' ]
#         set char \n
#         set i (math 1 + $i)
#       end
#       _escape_char $use_colour $char
#       set i (math 1 + $i)
#     end
#   end
# end


