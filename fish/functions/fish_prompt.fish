function fish_prompt
  set -l last_status $status

  # the time
  set_color --background magenta
  echo -n (date +" %I:%M %p ")
  set_color --background normal
  echo -n ' '

  # the path
  set_color --background magenta
  echo -n " "(pwd | sed s:$HOME:~:)" "
  set_color --background normal
  echo -n ' '

  # the git shell
  if set -l branch_name (git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1 /')
    set_color green --background magenta
    echo -n $branch_name
    set_color --background normal
  end

  # the prompt depends on the last status
  if [ $last_status = 0 ]
    echo -n \n"🐠 "
  else
    echo -n \n"🍣 " # sushi
    # other option: 🎣
  end
  set_color --background normal
  echo -n ' '

end
