Feature: ttyout
  Some programs change their output depending on whether stdout
  is a tty or not. This program will execute them with a tty stdout
  so that you can do things like redirect the tty output version into a shell.

  Scenario: Args get forwarded to the program
    Given I run "ttyout ruby -e 'p 123'"
    Then stderr is empty
    And stdout is "123"

  Scenario: The program's stdout is a tty
    Given the file "argprint":
    """
    #!/usr/bin/env ruby
    delimiter = "\n"
    delimiter = " " if $stdout.tty?
    puts ARGV.join delimiter
    """
    And I run "chmod +x argprint"

    # stdout is not normally a tty
    When I run "./argprint a b c | cat"
    And stdout is:
    """
    a
    b
    c
    """

    # stdout is a tty when run with ttyout
    When I run "ttyout ./argprint a b c | cat"
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

  @wip
  Scenario: It kills the program when it dies
    # Given it skips... sigh
    Given the file "tmp.rb":
    """
    begin
      read, write = IO.pipe
      pid = Process.spawn 'ttyout ruby -e "loop { p Process.pid; sleep }"', out: write
      write.close
      child_pid = read.gets.to_i
      Process.kill 'SIGKILL', pid
      Process.wait child_pid
    rescue Errno::ECHILD
      # this is what we want (is there no way to ask whether a process exists?)
    ensure
      read.close unless read.closed?
    end
    """
    When I run "ruby tmp.rb"
    Then stderr is empty
    And the exit status is 0
    And stdout is empty

  Scenario: It closes stdout for the program when its stdout is closed
  Scenario: It

  Scenario: No args, or '-h', '--help' prints help
    When I run 'ttyout'
    Then stdout includes "USAGE"
    And the exit status is 0

    When I run 'ttyout -h'
    Then stdout includes "USAGE"
    And the exit status is 0

    When I run 'ttyout --help'
    Then stdout includes "USAGE"
    And the exit status is 0

    When I run 'ttyout ls'
    Then stdout does not include "USAGE"
    And the exit status is 0
