Pry.editor = 'vim'

# ensure hooks have been initialized prior to use (https://github.com/pry/pry/issues/1271)
Pry.config.hooks

# for debugging pry: find a config option
def find_config(name, stream: STDOUT, config: Pry.toplevel_binding.local_variable_get('_pry_').config)
  puts = lambda { |message| stream.puts message }
  name = name.intern
  puts.call "Searching for #{name.inspect} in #{config.inspect}"
  if config.methods.include?(name)
    puts.call "  Found a #{name.inspect} method!"
    return config.__send__ name
  end
  puts.call "  Does not have an #{name.inspect} method defined"

  if config.key? name
    puts.call "  Found an #{name.inspect} key! returning its value!"
    return config[name]
  end
  puts.call "  Does not have a #{name.inspect} key"

  if config.default
    puts.call "  Going on to next node in linked list"
    __send__(__method__, name, stream: stream, config: config.default)
  else
    puts.call "  That's the end of the linked list, should get a no method error"
  end
end

