Feature: ttyout
  Some programs change their output depending on whether stdout
  is a tty or not. This program will execute them with a tty stdout
  so that you can do things like redirect the tty output version into a shell.

  Scenario: Program with args
    Given the file "argprint":
    """
    #!/usr/bin/env ruby
    delimiter = "\n"
    delimiter = " " if $stdout.tty?
    puts ARGV.join delimiter
    """
    And I run "chmod +x argprint"
    # When I run "./argprint a b c"
    # Then stdout is "a b c\n"
    When I run "./argprint a b c | cat"
    Then stderr is empty
    And stdout is:
    """
    a
    b
    c
    """
    When I run "ttyout ./argprint a b c | cat"
    Then stderr is empty
    And stdout is "a b c"

  Scenario: Stdin is forwarded to the program
    Given the file "printstdin":
    """
    #!/usr/bin/env ruby
    if $stdout.tty?
      print $stdin.read.upcase
    else
      print $stdin.read
    end
    """
    And I run "chmod +x printstdin"
    When I run "echo hello | ./printstdin | cat"
    Then stdout is "hello"
    When I run "echo hello | ttyout ./printstdin | cat"
    Then stdout is "HELLO"

  Scenario: It exits with the program's exit status
    When I run "ttyout ruby -e 'exit 12'"
    Then the exit status is 12

  Scenario: No args, or '-h', '--help' prints help
    When I run 'ttyout'
    Then stdout includes "USAGE"
    When I run 'ttyout -h'
    Then stdout includes "USAGE"
    When I run 'ttyout --help'
    Then stdout includes "USAGE"
    When I run 'ttyout ls'
    Then stdout does not include "USAGE"
