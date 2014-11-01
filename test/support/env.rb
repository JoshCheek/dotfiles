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
