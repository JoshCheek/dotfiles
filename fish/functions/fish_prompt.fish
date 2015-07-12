# Screenshot: https://s3.amazonaws.com/josh.cheek/images/scratch/fish-prompt.gif

function fish_prompt-status_bar -d 'Info I want to see just above my prompt'
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

  # next line
  echo
end


function fish_prompt-colour -d 'blue if the exit status is successful, red if unsuccessful'
  if [ $argv[1] = 0 ]
    echo blue
  else
    echo red
  end
end


function fish_prompt-animated_prompt -e fish_postexec -d 'Animates a swimming fishy ^_^'
  set -l last_status $status

  fish_prompt-status_bar
  set_color (fish_prompt-colour $last_status)

  for swimmy_fishy in   "><(((º> "\
                      \r".><(((º> "\
                      \r"¸.><(((º> "\
                      \r".¸.><(((º> "\
                      \r"·.¸.><(((º> "\
                      \r"`·.¸.><(((º> "\
                      \r"¯`·.¸.><(((º> "\
                      \r"´¯`·.¸.><(((º> "\
                      \r"·´¯`·.¸.><(((º> "\
                      \r".·´¯`·.¸.><(((º> "\
                      \r"¸.·´¯`·.¸.><(((º> "\
                      \r"¸¸.·´¯`·.¸.><(((º> "\
                      \r".¸¸.·´¯`·.¸.><(((º> "\
                      \r"·.¸¸.·´¯`·.¸.><(((º> "
    sleep 0.01
    echo -n $swimmy_fishy
  end
end


function fish_prompt -d 'Redraw prompt after animating so that Fish can reason about it'
  set -l last_status $status

  # go up 2 lines
  echo -n \e"[2A"

  fish_prompt-status_bar
  set_color (fish_prompt-colour $last_status)
  echo -n "·.¸¸.·´¯`·.¸.><(((º> "
  set_color normal
end
