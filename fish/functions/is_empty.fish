function is_empty -d 'Tells whether a variable is empty or not'
  [ 0 -eq (string length $argv) ]
end
