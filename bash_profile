if [[ -e "$HOME/.bashrc" ]]; then
  source "$HOME/.bashrc"
fi

# Environment Variables
  export EDITOR='vim'
  export PATH="$HOME/bin:$HOME/code/dotfiles/bin:$HOME/.cargo/bin:$PATH"
  export BAT_THEME=TwoDark # https://github.com/sharkdp/bat

# tab completion
# if [ -f /usr/local/share/bash-completion/bash_completion ]; then
#   . /usr/local/share/bash-completion/bash_completion
# fi

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
      # -l long format
      # -F `/` after dirs, `*` after exe, `@` after symlink
      # -G colorize
      # -g suppress owner
      # -o suppress group
      # -h humanize sizes
      # -q print nongraphic chars as question marks
      ls -lFGgohq
    }

  # meta-p and meta-n: "starts with" history searching
  # taken from http://blog.veez.us/the-unix-canon-n-p
  # bind '"\ep": history-search-backward'
  # bind '"\en": history-search-forward'

  # suspended processes
    alias j=jobs

    for i in $(seq 30); do
      # Type the number to foreground that job
      alias "$i=fg %$i"

      # kn to kill that job
      alias "k$i=kill -9 %$i"
    done

    # kill all jobs
    ka () {
      for job_num in $(jobs | ruby -ne 'puts $_[/\d+/]'); do
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
    last_status="$?"

    # time
    ps1="$(prompt_segment " \@ ")"

    # cwd
    ps1="${ps1} $(prompt_segment " \w ")"

    # git branch
    git_branch=`parse_git_branch`
    if [[ ! -z "$git_branch" ]]; then ps1="${ps1} $(prompt_segment " $git_branch " 32)"; fi

    # next line
    ps1="${ps1}\n"

    # prompt char
    if [[ "$last_status" = "0" ]]; then
      ps1="${ps1}\[\033[92m\]\$\[\033[39m\]"
    else
      ps1="${ps1}\[\033[91m\]\$\[\033[39m\]"
    fi

    # padding
    ps1="${ps1} "

    # output
    PS1="$ps1"
  }

  PROMPT_COMMAND='build_mah_prompt'
