# Helpers

# NOTE: If you export any variables from the sourced file,
# they need to be set with global. EG:
#
#     set -gx PATH some/private/path PATH
#
function maybe_source
  if test -e $argv[1]
    source $argv[1]
  end
end

function maybe_prepend_path
  set -l to_add
  for dir in $argv
    if test -d $dir
      set to_add $to_add $dir
    end
  end
  set --global --export PATH $to_add $PATH
end


# Ruby environment, load it first b/c I choose the ruby in the private config
maybe_source /usr/local/share/chruby/chruby.fish

# Homebrew / Miniconda (https://conda.io/miniconda.html)
maybe_prepend_path \
  /Users/josh/miniconda2/bin \
  /usr/local/bin /usr/local/sbin

# pyenv is rbenv, but for Python. It's way better than virtualenv, eg it was able
# to install Keras and Jupyter, where virtualenv was not. Plus, it doesn't expect
# to be running inside of a bash shell, and you can see that setting it up only
# requires setting a few env vars, so it's cheap to load
if test -d $HOME/.pyenv
  set --export PYENV_ROOT            $HOME/.pyenv
  set --export PYTHON_CONFIGURE_OPTS --enable-framework
  set --export PATH                  $PYENV_ROOT/bin $PYENV_ROOT/shims $PATH
end

# rust lang
maybe_prepend_path $HOME/.cargo/bin

# nodenv is rbenv, but for node js. It's dramatically better than nvm in terms
# of load time, working outside bash fish, and not constantly needing my attention
if test -d $HOME/.nodenv
  # https://github.com/nodenv/nodenv/blob/18489d7bf319fde4edc942cce7f3b1caf1b12214/libexec/nodenv-sh-shell#L33
  set -x NODENV_SHELL fish

  maybe_prepend_path $HOME/.nodenv/bin $HOME/.nodenv/shims
  maybe_source $HOME/.nodenv/completions/nodenv.fish

  # # rehash every time, just to reduce weird errors (doesn't seem to be expensive)
  # command nodenv rehash 2>/dev/null

  function nodenv
    set command $argv[1]
    set -e argv[1]

    switch "$command"
    case rehash shell
      source (nodenv "sh-$command" $argv|psub)
    case '*'
      command nodenv "$command" $argv
    end
  end
end

# For golang
if test -d "$HOME/golang"
  set --export GOPATH           "$HOME/golang"
  set --export PATH             $PATH "$GOPATH/bin"
  set --export PKG_CONFIG_PATH  "/usr/lib/pkgconfig"
end

# My custom executables
maybe_prepend_path $HOME/code/dotfiles/bin  # executables in dotfiles
maybe_prepend_path $HOME/bin                # overrides from this machine

# Rails cucumber integration looks for this env var to decide how to display output
set --export CUCUMBER_FORMAT pretty

# Custom kill and foreground commands since I work with a lot of background jobs
for i in (seq 30)
  eval "function $i
          fg %$i
        end"
end

# Tell homebrew not to auto update if I've already done it this week
set --export HOMEBREW_AUTO_UPDATE_SECS (echo '60 * 60 * 24 * 7' | bc)

# Don't print a greeting when I start the shell
set fish_greeting

# Have `tree` colour directories yellowish
# this shit is so badly documented and inconsistent,
# `ls` doesn't even use it, despite talking about it in its man page
set --export LS_COLORS 'di=33'

# Make Cmus music player detachable (https://github.com/cmus/cmus/wiki/detachable-cmus)
# NOTE: To get `cmus` to background itself when you press "q",
#       you need to run this from within it: `:bind -f common q shell screen -d cmus`
#       only need to do this once, it remembers configuration.
alias cmus='screen -q -r -D cmus; or screen -S cmus (which cmus)'

# Private / machine dependent configuration
maybe_source $HOME/.config/fish/private_config.fish

# Bat (a better cat) https://github.com/sharkdp/bat
set -x BAT_THEME TwoDark
