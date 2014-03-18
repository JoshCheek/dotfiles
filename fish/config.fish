set --export PATH "$HOME/bin"               \
                  "$HOME/code/dotfiles/bin" \
                  "/usr/local/bin"          \
                  "$HOME/.rbenv/shims"      \
                  "$HOME/.cabal/bin"        \
                  $PATH

# rails cucumber integration looks for this env var to decide how to display output
set --export CUCUMBER_FORMAT pretty

alias strip "ruby -ne 'print \$_.strip'" # should make this a real function

# for configs that I don't want in my public git (ie work stuff)
if test -e ~/.config/fish/private_config.fish
  .        ~/.config/fish/private_config.fish
end

set -x she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist ~/Dropbox/passwords

for i in (seq 30)
  eval "function $i
          fg %$i
        end"
  eval "function k$i
          kill -9 %$i
        end"
end

source /usr/local/share/chruby/chruby.fish
