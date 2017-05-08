function 2dir
  # call popd to return later
  pushd (eval $history[1] | sed 's/\/[^\/]*$//')
end
