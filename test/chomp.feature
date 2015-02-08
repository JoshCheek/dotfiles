Feature: chomp
  Remove a trailing newline from the end of output

  Scenario: chomp emits the same output whether there is a newline or not
    When I run "ruby -e 'puts ?a'  | chomp > a1"
    And  I run "ruby -e 'print ?a' | chomp > a2"
    When I run "diff a1 a2"
    Then stdout is empty
    And  stderr is empty
    And  the exit status is 0

  Scenario: That output does not end in a newline
    When I run "echo hi | chomp | ruby -e 'exit gets == %(hi)'"
    Then the exit status is 0
