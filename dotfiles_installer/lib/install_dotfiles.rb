require 'fileutils'
require 'open3'

class InstallDotfiles
  CloneDirExistsError = Class.new StandardError

  include FileUtils

  attr_accessor :stdin, :stdout

  def initialize(stdin, stdout)
    @fileutils_output = stdout
    self.stdin        = stdin
    self.stdout       = stdout
  end

  def symlink(options)
    existing          = File.expand_path options.fetch :existing
    new               = File.expand_path options.fetch :new
    new_is_symlink    = Kernel.test 'l', new
    new_exists        = Kernel.test 'e', new
    redundant_symlink = new_is_symlink && File.realdirpath(new) == File.realdirpath(existing)
    will_clobber      = !redundant_symlink && new_exists
    noop              = redundant_symlink
    # expect    new -> actual
    # trying to new -> desired
    # expectations:
    #   new_is_symlink     true
    #   new_exists         true <-- this is false
    #   redundant_symlink  false
    #   will_clobber       true
    #   noop               false
    require "pry"
    binding.pry if $PRYTIME
    if will_clobber
      should_overwrite = prompt "Overwrite #{new.inspect}? [y/n]", /^(y|n)/i do |response|
        response.downcase.start_with? 'y'
      end
      if should_overwrite
        rm_rf new
        ln_s existing, new
      end
      # Informative message here?
    else
      stdout.print "Skipping: " if noop
      mkdir_p File.dirname(new), verbose: true, noop: noop
      stdout.print "Skipping: " if noop
      ln_s    existing, new,     verbose: true, noop: noop
    end
  end

  def append(file_name, content)
    FileUtils.mkdir_p File.dirname file_name
    FileUtils.touch file_name
    includes_content = File.read(file_name).include? content
    unless includes_content
      File.open(file_name, 'a') { |file| file.puts content }
    end
  end

  def git_clone_or_pull(existing_repo, location)
    stdout, stderr, status = Open3.capture3 'git', 'clone', existing_repo, location
    return if status.success?
    if stderr['already exists']
      Dir.chdir location do
        if Kernel.test 'd', '.git'
          out, err, status = Open3.capture3 'git', 'pull'
        else
          raise CloneDirExistsError, "#{location} exists and is not a git repo"
        end
      end
    else
      raise "Some unexpected error while cloning to #{location.inspect}: #{stderr.inspect}"
    end
  end

  def curl(target_file, url)
    FileUtils.mkdir_p File.dirname target_file
    if Kernel.test('e', target_file)
      should_overwrite = prompt "Overwrite #{target_file.inspect}? [y/n]", /^(y|n)/i do |response|
        response.downcase.start_with? 'y'
      end
      return unless should_overwrite
      FileUtils.rm target_file
    end
    Kernel.system %Q(curl -Sso #{target_file.inspect} #{url.inspect})
  end


  private

  def prompt(message, validation, &interpret)
    begin
      stdout.write message
      result = stdin.gets
    end until result =~ validation
    interpret.call result
  end
end
