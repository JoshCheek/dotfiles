Pry.editor = 'vim'

# ensure hooks have been initialized prior to use (https://github.com/pry/pry/issues/1271)
Pry.config.hooks

# for debugging pry: find a config option
def find_config(name, options={})
  # setup locals
  name   = name.intern
  stream = options.fetch :stream, STDOUT
  config = options.fetch :config, Pry.toplevel_binding.eval('_pry_').config
  puts   = lambda { |message| stream.puts message }

  # find a method
  puts.call "Searching for #{name.inspect} in #{config.inspect}"
  if config.methods.include?(name)
    puts.call "  Found a #{name.inspect} method!"
    begin
      pry_method = Pry::Method.new(config.method name)
      code       = Pry::Code.from_method(pry_method)
      puts.call code.gsub(/^/, " "*6)
    rescue
      puts $! # not sure what would lead to this, but I'm pretty sure it can happen
    end
    return config.__send__ name
  end
  puts.call "  Does not have an #{name.inspect} method defined"

  # find a key
  if config.key? name
    puts.call "  Found an #{name.inspect} key! returning its value!"
    return config[name]
  end
  puts.call "  Does not have a #{name.inspect} key"

  # not in this node, continue down the list
  if config.default
    puts.call "  Going on to next node in linked list"
    __send__(__method__, name, stream: stream, config: config.default)
  else
    puts.call "  That's the end of the linked list, should get a no method error"
  end
end

