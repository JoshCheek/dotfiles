Feature: mrspec
  Minitest doesn't have a runner, but a runner would be really nice.
  RSpec has a nice runner... so lets join them together!

  Background:
    Given I run 'ruby -e "puts Dir[%(**/*_{spec,test}.rb)]" | xargs rm'

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

  Scenario: Registers minitest tests as RSpec tests, recording skips, passes, errors, failures
    Given the file "some_test.rb":
    """
    require 'minitest'
    class LotaStuffsTest < Minitest::Test
      def test_passes
      end

      def test_fails
        assert false
      end

      def test_errors
        raise "omg"
      end

      def test_skips
        skip
      end
    end
    """
    When I run "mrspec some_test.rb -f json"
    Then stdout includes "4 examples"
    And stdout includes "2 failures"
    And stdout includes "1 pending"

  Scenario: Works with Minitest::Spec
    # Commenting out for now, b/c RSpec's describe / non-monkey patching interfere with Minitest's
    # Given the file "some_spec.rb":
    # """
    # require 'minitest/spec'
    # describe 'mt' do
    #   it 'passes' do
    #     assert true
    #   end
    # end
    # """
    # When I run "mrspec some_spec.rb -f json"
    # Then stdout includes "1 example"
    # And stdout includes "0 failures"

  Scenario: Filters the runner and minitest code out of the backtrace do
    Given the file "some_test.rb":
    """
    require 'minitest'
    class LotaStuffsTest < Minitest::Test
      def test_errors
        raise "zomg"
      end
    end
    """
    When I run "mrspec some_test.rb"
    Then stdout does not include "minitest"
    And stdout does not include "mrspec"

  Scenario: --fail-fast flag
    Given the file "fails_fast_test.rb":
    """
    require 'minitest'
    class TwoFailures < Minitest::Test
      i_suck_and_my_tests_are_order_dependent!
      def test_1
        raise
      end
      def test_2
        raise
      end
    end
    """
    When I run 'mrspec fails_fast_test.rb --fail-fast'
    Then stdout includes "1 example"

  Scenario: -e flag
    Given the file "spec/first_spec.rb":
    """
    RSpec.describe 'a' do
      example('b') { }
    end
    """
    Given the file "test/first_test.rb":
    """
    require 'minitest'
    class FirstTest < Minitest::Test
      def test_1
      end
    end
    """
    And the file "test/second_test.rb":
    """
    require 'minitest'
    class SecondTest < Minitest::Test
      def test_2
      end
    end
    """
    When I run 'mrspec -e Second'
    Then stdout includes "1 example"
    And stdout does not include "2 examples"

  Scenario: Passing a filename overrides the default pattern
    # Commented out for now, b/c modifying the default pattern interferes with this
    # Given the file "spec/first_spec.rb":
    # """
    # RSpec.describe 'a' do
    #   example('b') { }
    # end
    # """
    # Given the file "test/first_test.rb":
    # """
    # require 'minitest'
    # class TwoFailures < Minitest::Test
    #   def test_1
    #   end
    # end
    # """
    # And the file "test/second_test.rb":
    # """
    # require 'minitest'
    # class TwoFailures < Minitest::Test
    #   def test_1
    #   end
    # end
    # """
    # When I run 'mrspec test/second_test.rb'
    # Then stdout includes "1 example"
    # And stdout does not include "2 examples"

  Scenario: Can tag minitest tests and run the tagged ones

