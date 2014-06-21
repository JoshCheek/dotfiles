# Environment Variables
  export EDITOR='vim'
  export PATH="$HOME/bin:$PATH"

# ALIASES
  # path
    alias     ..="cd .."
    alias    ...="cd ../.."
    alias   ....="cd ../../.."
    alias  .....="cd ../../../.."
    alias ......="cd ../../../../.."

    # override cd b/c I always want to list dirs after I cd
    # note that this won't work with rvm b/c it overrides cd.
    cd() {
      builtin cd "$@"
      l
    }

  # meta-p and meta-n: "starts with" history searching
  # taken from http://blog.veez.us/the-unix-canon-n-p
  bind '"\ep": history-search-backward'
  bind '"\en": history-search-forward'

  # suspended processes
    alias j=jobs

    for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
    do
      alias "$i=fg %$i"
      alias "k$i=kill -9 %$i"
    done

    # kill jobs by job number, or range of job numbers
    # example: k 1 2 5
    # example: k 1..5
    # example: k 1..5 7 10..15
    k () {
      for arg in $@;
      do
        if [[ "$arg" =~ ^[0-9]+$ ]]
        then
          kill -9 %$arg
        else
          start=$(echo "$arg" | sed 's/[^0-9].*$//')
          end=$(echo "$arg" | sed 's/^[0-9]*[^0-9]*//')

          for (( n=start; n<=end; n++ ))
          do
            kill -9 %$n
          done
        fi
      done
    }

    # kill all jobs
    ka () {
      for job_num in $(jobs | ruby -ne 'puts $_[/\d+/]')
      do
        kill -9 "%$job_num"
      done
    }

  # generic
    alias ss="python -m SimpleHTTPServer" # simple server (serves current dir on port 8000)


# PROGRAMS (functions, binaries, aliases that behave like programs)

  # Give it a # and a dir, it will cd to that dir, then `cd ..` however many times you've indicated with the number
  # The number defaults to 1, the dir, if not provided, defaults to the output of the previous command
  # This lets you find the dir on one line, then run the command on the next
    2dir() {
      last_command="$(history | tail -2 | head -1 | sed 's/^ *[0-9]* *//')"
      count="${1-1}"
      name="${2:-$($last_command)}"
      while [[ $count > 0 ]]
        do
          name="$(dirname "$name")"
          ((count--))
      done
      echo "$name"
      cd "$name"
    }

  # take you to the dir of a file in a gem. e.g. `2gem rspec`
    2gem () {
      cd "$(dirname $(gem which $1))"
    }


# PROMPT
  function parse_git_branch {
    branch=`git rev-parse --abbrev-ref HEAD 2>/dev/null`
    if [ "HEAD" = "$branch" ]; then
      echo "(no branch)"
    else
      echo "$branch"
    fi
  }

  function prompt_segment {
    if [[ ! -z "$1" ]]; then
      echo "\[\033[${2:-37};45m\]${1}\[\033[0m\]"
    fi
  }

  function build_mah_prompt {
    # time
    ps1="$(prompt_segment " \@ ")"

    # cwd with coloured current directory
    # path="$(dirname `pwd`)"
    # dir="$(basename `pwd`)"
    # ps1="${ps1} $(prompt_segment " ${path}/")$(prompt_segment "$dir " 34)"

    # cwd
    ps1="${ps1} $(prompt_segment " \w ")"

    # git branch
    git_branch=`parse_git_branch`
    if [[ ! -z "$git_branch" ]]; then ps1="${ps1} $(prompt_segment " $git_branch " 32)"; fi

    # next line
    ps1="${ps1}\n\$ "

    # output
    PS1="$ps1"
  }

  PROMPT_COMMAND='build_mah_prompt'
