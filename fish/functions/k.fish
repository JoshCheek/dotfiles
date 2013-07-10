# kill jobs by job number, or range of job numbers
# example: k 1 2 5
# example: k 1..5
# example: k 1..5 7 10..15
function k
  for arg in $argv
    if ruby -e "exit ('$arg' =~ /^[0-9]+\$/ ? 0 : 1)"
      kill -9 %$arg
    else
      set _start (echo "$arg" | sed 's/[^0-9].*$//')
      set _end   (echo "$arg" | sed 's/^[0-9]*[^0-9]*//')

      for n in (seq $_start $_end)
        kill -9 %"$n"
      end
    end
  end
end
