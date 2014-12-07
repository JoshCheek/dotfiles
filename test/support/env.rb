require 'haiti'

Haiti.configure do |config|
  config.proving_grounds_dir = File.expand_path '../../proving_grounds', __FILE__ # dotfiles/test/proving_grounds
  config.bin_dir             = File.expand_path '../../../bin',          __FILE__ # dotfiles/bin
end

module GeneralHelpers
  def pwd
    Haiti.config.proving_grounds_dir
  end
end

When 'I pry' do
  require "pry"
  binding.pry
end

define_steps = lambda do |*matchers, &definition|
  matchers.each { |matcher| Given matcher, &definition }
end

define_steps.call(
  /^(stderr|stdout) is exactly:$/,
  /^(stderr|stdout) is exactly "([^"]*?)"$/,
  /^(stderr|stdout) is exactly '([^']*?)'$/
) { |stream_name, output|  expect(@last_executed.send stream_name).to eq eval_curlies(output) }

define_steps.call(
  'I previously copied "$text"',
  "I previously copied '$text'",
  "I previously copied:",
) { |to_add| Open3.popen3("pbcopy") { |stdin, *| stdin.write eval_curlies(to_add) } }

define_steps.call(
  'the clipboard now contains "$text"',
  "the clipboard now contains '$text'",
  "the clipboard now contains:",
) { |to_add|
  out, error, status = Open3.capture3("pbpaste")
  raise "Failed: #{error.inspect}" unless status.success?
  expect(out).to eq eval_curlies(to_add)
}

define_steps.call(
  'the directory "$dirname"',
  "the directory '$dirname'",
) { |dirname|
  Haiti::CommandLineHelpers.in_proving_grounds {
    FileUtils.mkdir_p dirname
  }
}

Then 'the program ran successfully' do
  expect(@last_executed.stderr).to eq ""
  expect(@last_executed.exitstatus).to eq 0
end

# Then 'stdout is the JSON:' do |json|
#   require 'json'
#   expected = JSON.parse(json)
#   actual   = JSON.parse(@last_executed.stdout)
#   expect(actual).to eq expected
# end

# Given %q(the file '$filename' '$body') do |filename, body|
#   Haiti::CommandLineHelpers.write_file filename, eval_curlies(body)
# end


# Set up recording programs, for programs that delegate to others
test_helper_bin  = File.join(Haiti.config.proving_grounds_dir, 'bin')
recorded_results = File.join(Haiti.config.proving_grounds_dir, '.recorded')
Before do
  FileUtils.mkdir_p test_helper_bin
  File.write recorded_results, ''
end
ENV['PATH'] = "#{test_helper_bin}:#{ENV['PATH']}"

require 'time'
program_identifier = Time.now.strftime("%a-%b-%d-%Y-%H:%M:%S")

identifier_for = lambda do |bin_name|
  "#{program_identifier}-#{bin_name}"
end

make_bin = lambda do |name|
  program_name = File.join(test_helper_bin, name)
  File.write program_name, <<-PROGRAM.gsub(/^\s+/, '')
    #!/usr/bin/env ruby
    File.open(#{recorded_results.inspect}, "a") { |file|
      file.puts #{identifier_for[name].inspect} + " \#{ARGV.inspect}"
    }
  PROGRAM
  FileUtils.chmod 0755, program_name
end

recorded_lines_for = lambda do |name|
  identifier = identifier_for[name]
  File.read(recorded_results).lines.select { |line| line.start_with? identifier }
end

Given "the recording program '$name'" do |name|
  Haiti::CommandLineHelpers.in_proving_grounds do
    make_bin.call eval_curlies name
  end
end

Then "the recording program '$name' was invoked with [$args]" do |name, args|
  Haiti::CommandLineHelpers.in_proving_grounds do
    lines = recorded_lines_for[eval_curlies name]
    args  = eval_curlies(args)
    expect(lines).to be_any { |line| line.include? args }
  end
end

Then /^the recording program '(.*?)' was invoked (\d+) times?$/ do |name, expected_times|
  Haiti::CommandLineHelpers.in_proving_grounds do
    actual_times   = recorded_lines_for[eval_curlies name].count
    expected_times = eval_curlies(expected_times).to_i
    expect(actual_times).to eq expected_times
  end
end
