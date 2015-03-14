# various paths
set --export PATH $HOME/bin          \
                  /usr/local/bin     \
                  $HOME/.rbenv/shims \
                  $PATH              \
                  $HOME/.cabal/bin

# Rails cucumber integration looks for this env var to decide how to display output
set --export CUCUMBER_FORMAT pretty

# Custom kill and foreground commands since I work with a lot of background jobs
for i in (seq 30)
  eval "function $i
          fg %$i
        end"
end

# Load ruby. Interface is less helpful than rbenv
# but Brixen says it works with rbx in ways that rbenv's assumptions won't let it
source /usr/local/share/chruby/chruby.fish

# Don't print a greeting when I start the shell
set --erase fish_greeting

# For configs that I don't want in my public git (ie work stuff and stuff that changes across computers)
if test -e ~/.config/fish/private_config.fish
  source   ~/.config/fish/private_config.fish
end

# Have `tree` colour directories yellowish
# this shit is so badly documented and inconsistent
set --export LS_COLORS 'di=33'
