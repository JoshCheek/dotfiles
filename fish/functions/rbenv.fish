function rbenv_shell
  set -l vers $argv[1]

  switch "$vers"
  case '--complete'
    echo '--unset'
    echo 'system'
    command rbenv versions --bare
    return
  case '--unset'
    set -e RBENV_VERSION
    return 1
  case ''
    if [ -z "$RBENV_VERSION" ]
      echo "rbenv: no shell-specific version configured" >&2
      return 1
    else
      echo "$RBENV_VERSION"
      return
    end
  case '*'
    set -gx RBENV_VERSION "$vers"
  end
end

function rbenv_lookup
  if [ -z $argv[1] ]
    return 1
  end
  set -l vers (command rbenv versions --bare | sort | grep -- "$argv[1]" | tail -n1)

  if [ ! -z "$vers" ]
    echo $vers
    return
  else
    echo $argv
    return
  end
end

function rbenv
  set -l command $argv[1]
  [ (count $argv) -gt 1 ]; and set -l args $argv[2..-1]

  switch "$command"
  case shell
    rbenv_shell (rbenv_lookup $args)
    ruby -v
  case local global
    command rbenv $command (rbenv_lookup $args)
    ruby -v
  case '*'
    command rbenv $command $args
  end
end

