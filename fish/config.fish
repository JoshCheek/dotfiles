set --export PATH "$HOME/bin"               \
                  "$HOME/code/dotfiles/bin" \
                  "/usr/local/bin"          \
                  "$HOME/.rbenv/shims"      \
                  "$HOME/.cabal/bin"        \
                  $PATH

# tune Ruby's GC
set --export RUBY_HEAP_MIN_SLOTS           500000
set --export RUBY_HEAP_SLOTS_INCREMENT     250000
set --export RUBY_HEAP_SLOTS_GROWTH_FACTOR 1
set --export RUBY_GC_MALLOC_LIMIT          50000000

# rails cucumber integration looks for this env var to decide how to display output
set --export CUCUMBER_FORMAT pretty

alias strip "ruby -ne 'print \$_.strip'" # should make this a real function

# for configs that I don't want in my public git (ie work stuff)
if test -e ~/.config/fish/private_config.fish
  .        ~/.config/fish/private_config.fish
end

set -x she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist ~/Dropbox/passwords
