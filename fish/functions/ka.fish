function ka
  for n in (jobs | awk 'NR > 0 { print $1 }')
    kill -9 %"$n"
  end
end
