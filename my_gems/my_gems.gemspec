# -*- encoding: utf-8 -*-
require File.expand_path('../lib/my_gems/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Josh Cheek"]
  gem.email         = ["josh.cheek@gmail.com"]
  gem.description   = %q{Just load up the gems and env that I like}
  gem.summary       = %q{Just load up the gems and env that I like -- not meant for anyone else (hence no rubygems release)}
  gem.homepage      = ""
  gem.files         = %w[
    ./lib/my_gems/version.rb
    ./lib/my_gems.rb
    ./my_gems.gemspec
    ./README.md
  ]


  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "my_gems"
  gem.require_paths = ["lib"]
  gem.version       = MyGems::VERSION
end
