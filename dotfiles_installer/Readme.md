# Dotfiles Installer
Installs my dotfiles onto a new system.

For specifics of what will be installed, run the binary with --help or --dry-run

## Things Considered (i.e. can you feel safe running this?)
* TODO: All options can be individually prompted to see if you want to do them with --prompt
* TODO: You can see what will happend with the `--dry-run` flag
* TODO: Prints what it is doing as it does it so that you have a record
* Symlinking
  * Creates the symlink if it doesn't exist
  * Skips when symlinking would be redundant
  * Prompts when symlinking would clober something already existing (e.g. file or symlink to another location)
* Appending to files
  * Skips it file exists and already includes the content
  * Makes the file if it doesn't exist
  * Appends to the end of the file if it does not include the content
* Git repositories
  * Fails if the dir exists and is not a git repo
  * Clones the repo when the repo does not exist
  * Pulls the repo when the repo does exist
* Curl
  * Prompts for overwrite if the file already exists
  * Can curl into a file in a dir that doesn't exist (e.g. mkdir -p before curling)
  * Invokes curl with --silent and --show-error, writes it into the desired file

## TODO
NOW:
  prints what it is doing instead of quietly chugging away (via flag)
  --dry-run
    all commands can take this option
    binary passes them in
  --prompt
    will prompt for each option
  --help
    lists what program does
    lists the flags that can be passed
    runs dry run
  takes an ARGV of code dir
    installs words and cln there
    symlinks words and cln bins from ~/bin

* Install Apple build tools to get gcc?
* Allow it to install brew programs?
  * ack
  * ctags
  * fish
  * git
  * jq
  * tree
  * wget
