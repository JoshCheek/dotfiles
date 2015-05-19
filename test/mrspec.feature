Feature: mrspec
  Minitest doesn't have a runner, but a runner would be really nice.
  RSpec has a nice runner... so lets join them together!

  Scenario: Finds spec/**/*_spec.rb and test/**/*_test.rb
    Given the file "spec/a_spec.rb":
    """
    RSpec.describe 'a' do
      it('passes') { }
    end
    """
    And the file "spec/dir/b_spec.rb":
    """
    RSpec.describe 'b' do
      it('passes') { }
    end
    """
    And the file "test/c_test.rb":
    """
    require 'minitest'
    class CTest < Minitest::Test
      def test_passes
      end
    end
    """
    And the file "test/dir/d_test.rb":
    """
    require 'minitest'
    class DTest < Minitest::Test
      def test_passes
      end
    end
    """
    When I run 'mrspec -f json'
    Then the program ran successfully
    And stdout includes "4 examples"
    And stdout includes "0 failures"

  Scenario: Registers minitest tests as RSpec tests, recording skips, passes, errors, failures, #assertions
  Scenario: Works with Minitest::Spec
  Scenario: Filters the runner and minitest code out of the backtrace
  Scenario: --fail-fast flag
  Scenario: -e flag
  Scenario: --format flag
  Scenario: Can tag minitest tests and run the tagged ones

