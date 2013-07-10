function fish_prompt
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
  if git branch ^&- >&-
    set_color green --background magenta
    echo -n (git branch --no-color ^ /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1 /')
    set_color --background normal
  end

  # the prompt
  echo -n \n"🐠 "
end
