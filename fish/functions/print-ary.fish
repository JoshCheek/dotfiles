function print-ary --description 'Prints a fish array with each entry on its own line'
  # should it error if argv is emptpy?
  for entry in $argv
    echo $entry
  end
  return 0
end
