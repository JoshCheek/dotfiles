ansi_color_number() {
  case "$1" in
    black)   echo 0;;
    red)     echo 1;;
    green)   echo 2;;
    yellow)  echo 3;;
    blue)    echo 4;;
    magenta) echo 5;;
    cyan)    echo 6;;
    white)   echo 7;;
    *)       echo "UNKNOWN: $1" >&2
             return 1;;
  esac
}

bash_assert() {
  if test -z "$1"
  then
    echo "$2" >&2
    exit 1
  fi
}

colour_sequence() {
  # init vars
  codes=""
  text=""

  # parse args into vars
  for arg in $@
  do
    if [[ "$arg" =~ ^fg(.*)$ ]]
    then
      color="${BASH_REMATCH[1]}"
      number="$(ansi_color_number $color)"
      codes="${codes};3${number}"
    elif [[ "$arg" =~ ^bg(.*)$ ]]
    then
      color="${BASH_REMATCH[1]}"
      number="$(ansi_color_number $color)"
      codes="${codes};4${number}"
    else
      text="${text} ${arg}"
    fi
  done

  # assert provided required args
  bash_assert "$codes" "No colors given! (text is:$text)" || exit $?
  bash_assert "$text" "No text given!"  || exit $?

  # remove leading delimiters since IDK how to just make a fkn array and join them
  codes="$(echo "$codes" | cut -c 2-)"
  text="$(echo "$text" | cut -c 2-)"

  # emit the escape sequence
  echo $'\e['"${codes}m${text}"$'\e[0m'
}

# happy paths
#   colour_sequence fgred bgblue the message
#   colour_sequence bgred fgblack the message
# sad paths
#   colour_sequence
#   colour_sequence message
#   colour_sequence fgred
