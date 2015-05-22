Feature: chomp
  Stream input
  Basically cat for one file, but with the nice features you get from setting stdin to a file.

  Background:
    Given the file "input.txt":
    """
    here is
    some content
    """

  Scenario: It runs the program, correctly passing and escaping the args
    When I run "fin input.txt echo 'a  b!'"
    Then the program ran successfully
    And stdout is "a  b!"

  Scenario: It gives the file to cat when there is no program to run
    When I run "fin input.txt"
    Then the program ran successfully
    And stdout is:
    """
    here is
    some content
    """

  Scenario: The input is seekable
    When I run "fin input.txt ruby -e 'p $stdin.read; $stdin.seek 0; p $stdin.read'"
    Then the program ran successfully
    And stdout is:
    """
    "here is\nsome content"
    "here is\nsome content"
    """

  Scenario: help screen
    When I run "fin -h"
    Then the program ran successfully
    And stdout includes "Usage: fin"

    When I run "fin --help"
    Then the program ran successfully
    And stdout includes "Usage: fin"
