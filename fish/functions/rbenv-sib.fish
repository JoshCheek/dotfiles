function rbenv-sib
  if [ "$argv[1]" = "--off" ]
    rbenv shell --unset
    set -e RBENV_GEMSETS
  else
    rbenv shell 2
    set -gx RBENV_GEMSETS sib
  end
end
