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



# Ruby versions (I don't have rvm installed, so can't check to make sure it works, but I think it should.
#                If you try it, and it works for you, consider letting me know. If not, I wouldn't mind a pull request :)
  function which_ruby {
    if type rvm >/dev/null 2>&1; then
      echo rvm
    elif type rbenv >/dev/null 2>&1; then
      echo rbenv
    else
      echo Cannot determine Ruby version >&2
      exit 1
    fi
  }

  function switch_ruby_version {
    case "$(which_ruby)" in
    rvm)
      rvm   use   "$(rvm list strings      | grep -i "$1" | tail -1)" >/dev/null;;
    rbenv)
      rbenv shell "$(rbenv versions --bare | grep -i "$1" | tail -1)" >/dev/null;;
    *)
      echo "Don't know how to switch ruby versions in $which_ruby" 1>&2
      return 1;;
    esac
  }

  alias rrbx=" switch_ruby_version rbx     true && ruby -v"
  alias rmac=" switch_ruby_version macruby true && ruby -v"
  alias rjav=" switch_ruby_version jruby   true && ruby -v"
  alias r186=" switch_ruby_version 1.8.6   true && ruby -v"
  alias r187=" switch_ruby_version 1.8.7   true && ruby -v"
  alias r191=" switch_ruby_version 1.9.1   true && ruby -v"
  alias r192=" switch_ruby_version 1.9.2   true && ruby -v"
  alias r193=" switch_ruby_version 1.9.3   true && ruby -v"
  alias r2="   switch_ruby_version 2.0     true && ruby -v"
