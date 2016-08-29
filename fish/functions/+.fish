function + -d 'Adds the args to each line of stdin'
  set -l arithmetic (string join "" $argv)
  while read -l line
    echo $line + $arithmetic
  end | bc
end
