Feature: mrspec
  Minitest doesn't have a runner, but a runner would be really nice.
  RSpec has a nice runner... so lets join them together!

  Background:
    # stupid hacky solution to reset proving grounds instead of working in subdirs :/
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
        assert_equal 1, 2
      end

      def test_errors
        raise 'omg'
      end

      def test_skips
        skip
      end
    end
    """
    When I run "mrspec some_test.rb --no-color --format progress"

    # counts correctly
    Then stdout includes "4 examples"
    And stdout includes "2 failures"
    And stdout includes "1 pending"
    And stdout does not include "No examples found"

    # displays the failed assertion, not an error
    And stdout includes "Expected: 1"
    And stdout includes "Actual: 2"

    # displays the test's code, not the integration code
    And stdout includes "raise 'omg'"
    And stdout includes "assert_equal 1, 2"
    And stdout does not include "Minitest.run_one_method"


  Scenario: Works with Minitest::Spec
    Given the file "some_spec.rb":
    """
    require 'minitest/spec'
    describe 'mt' do
      it 'passes' do
        assert true
        if kind_of? Minitest::Spec
          puts "I am defined by Minitest::Spec"
        end
      end
    end
    """
    When I run "mrspec some_spec.rb -f json"
    Then stdout includes "1 example"
    And stdout includes "0 failures"
    And stdout includes "I am defined by Minitest::Spec"


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
    Given the file "spec/first_spec.rb":
    """
    RSpec.describe 'first spec' do
      example('rspec 1') { }
    end
    """
    Given the file "test/first_test.rb":
    """
    require 'minitest'
    class FirstTest < Minitest::Test
      def test_minitest_1
      end
    end
    """
    And the file "test/second_test.rb":
    """
    require 'minitest'
    class SecondTest < Minitest::Test
      def test_minitest_2
      end
    end
    """
    When I run 'mrspec -f d test/second_test.rb'
    Then stdout includes "1 example"
    And  stdout includes "minitest 2"
    And  stdout does not include "rspec 1"
    And  stdout does not include "minitest 1"


  Scenario: Can add metadata to examples, ie run only tagged tests
    Given the file "test/tag_test.rb":
    """
    require 'minitest'
    class TagTest < Minitest::Test
      meta first: true
      def test_1
        puts "ran test 1"
      end

      # multiple tags in meta, and aggregated across metas
      meta second: true, second2: true
      meta second3: true
      def test_2
        puts "ran test 2"
      end

      def test_3
        puts "ran test 3"
      end
    end
    """

    # only test_1 is tagged w/ first
    When I run 'mrspec test/tag_test.rb -t first'
    Then the program ran successfully
    Then stdout includes "1 example"
    And stdout includes "ran test 1"
    And stdout does not include "ran test 2"
    And stdout does not include "ran test 3"

    # test_2 is tagged w/ second, and second2 (multiple tags in 1 meta)
    When I run 'mrspec test/tag_test.rb -t second'
    Then stdout includes "1 example"
    And stdout includes "ran test 2"
    And stdout does not include "ran test 1"
    And stdout does not include "ran test 3"

    When I run 'mrspec test/tag_test.rb -t second2'
    Then stdout includes "1 example"
    And stdout includes "ran test 2"
    And stdout does not include "ran test 1"
    And stdout does not include "ran test 3"

    # test_2 is tagged with second3 (consolidates metadata until they are used)
    When I run 'mrspec test/tag_test.rb -t second3'
    Then stdout includes "1 example"
    And stdout includes "ran test 2"
    And stdout does not include "ran test 1"
    And stdout does not include "ran test 3"

    # for sanity, show that test_3 is actually a test, just not tagged (metadata gets cleared)
    When I run 'mrspec test/tag_test.rb'
    Then stdout includes "3 examples"
    And stdout includes "ran test 1"
    And stdout includes "ran test 2"
    And stdout includes "ran test 3"


  Scenario: Can add metadata to groups
    Given the file "tag_groups.rb":
    """
    require 'minitest'

    class Tag1Test < Minitest::Test
      classmeta tag1: true

      meta tag2: true
      def test_tagged_with_1_and_2
      end

      def test_tagged_with_1_only
      end
    end

    class UntaggedTest < Minitest::Test
      def test_untagged
      end
    end
    """

    # tag1 runs all tests in Tag1Test (b/c the tag is on the class)
    When I run 'mrspec -f d -t tag1 tag_groups.rb'
    Then the program ran successfully
    And  stdout includes "tagged with 1 and 2"
    And  stdout includes "tagged with 1 only"
    And  stdout does not include "untagged"

    # tag2 runs only Tag1Test#test_tagged_with_1_and_2 (b/c the tag is on the method)
    When I run 'mrspec -f d -t tag2 tag_groups.rb'
    Then the program ran successfully
    And  stdout includes "tagged with 1 and 2"
    And  stdout does not include "tagged with 1 only"
    And  stdout does not include "untagged"

    # no tags runs all tests (ignores all tagging)
    When I run 'mrspec -f d tag_groups.rb'
    Then the program ran successfully
    And  stdout includes "tagged with 1 and 2"
    And  stdout includes "tagged with 1 only"
    And  stdout includes "untagged"
