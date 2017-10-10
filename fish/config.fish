# Ruby environment, load it first b/c I choose the ruby in the private config
if test -e /usr/local/share/chruby/chruby.fish
  source   /usr/local/share/chruby/chruby.fish
end

# Private and custom configuration
if test -e ~/.config/fish/private_config.fish
  source   ~/.config/fish/private_config.fish
end

# Various paths
set --export PATH $HOME/bin /usr/local/bin /usr/local/sbin $PATH

if test -d $HOME/code/dotfiles/bin
  set --export PATH $HOME/code/dotfiles/bin $PATH
end

# For golang
if test -d "$HOME/golang"
  set --export GOPATH "$HOME/golang"
  set --export PATH   $PATH "$GOPATH/bin"
  set --export PKG_CONFIG_PATH  "/usr/lib/pkgconfig"
end

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


# nodenv is rbenv, but for node js. It's dramatically better than nvm in terms
# of load time (nvm in my bash profile ground my system to a halt), working
# outside bash fish, and not constantly needing my attention
set -gx PATH "$HOME/.nodenv/shims" $PATH
set -gx NODENV_SHELL fish
source '/usr/local/Cellar/nodenv/1.1.2/completions/nodenv.fish'
command nodenv rehash 2>/dev/null
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
