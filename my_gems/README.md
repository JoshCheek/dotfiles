# MyGems

Gems I want to use for myself, in my own dev environment.

## Installation

    $ gem build my_gems.gemspec
    WARNING:  no homepage specified
      Successfully built RubyGem
      Name: my_gems
      Version: 0.0.1
      File: my_gems-0.0.1.gem

    $ gem install my_gems-0.0.1.gem
    Successfully installed my_gems-0.0.1
    1 gem installed

# For use with bundler/pry

Currently this is the best solution I have

    $ cat ~/.pryrc
    begin
      require 'my_gems'
    rescue LoadError
      $LOAD_PATH << '~/.rvm/gems/ruby-1.9.3-p125@global/gems/my_gems-0.0.1/lib/'
      $LOAD_PATH << '~/.rvm/gems/ruby-1.9.3-p125@global/gems/yada_yada-0.1/lib/'
      $LOAD_PATH << '~/.rvm/gems/ruby-1.9.3-p125@global/gems/pasteboard-1.0/lib/'
      $LOAD_PATH << '~/.rvm/gems/ruby-1.9.3-p125@global/gems/pbcopy-1.0.1/lib/'
      require 'my_gems'
    end
