Pry.editor = 'vim'

# ensure hooks have been initialized prior to use (https://github.com/pry/pry/issues/1271)
Pry.config.hooks

Pry::Commands.block_command("\\q", "Quit, psql style") { exit }
