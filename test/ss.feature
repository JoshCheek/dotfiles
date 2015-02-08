Feature: ss
  I often want to work with screenshots,
  but they're stored off in this inaccessible directory.

  This tool is to help me do the things I commonly want to do with them.

  Background:
    Given the directory "Screenshots"
    And I run "rm Screenshots/Screenshot*.png"
    And the environment variable "SCREENSHOT_DIR" is set to "{{pwd}}/Screenshots"
    And the recording program 'open'

  Scenario: Help
    When I run "ss -h"
    Then the program ran successfully
    And stdout includes "Common screenshot shit"

    When I run "ss --help"
    Then the program ran successfully
    And stdout includes "Common screenshot shit"

    When I run "ss help"
    Then the program ran successfully
    And stdout includes "Common screenshot shit"

    And the recording program 'open' was invoked 0 times

  Scenario: Gets the most recent screenshot (date and time)
    Given the file "Screenshots/Screenshot 2014-10-27 23.51.18.png" "fake-screenshot"
    Given the file "Screenshots/Screenshot 2014-10-28 20.00.00.png" "fake-screenshot"
    Given the file "Screenshots/Screenshot 2014-10-28 10.00.00.png" "fake-screenshot"
    When I run "ss"
    Then the program ran successfully
    And  stdout includes "{{pwd}}/Screenshots/Screenshot 2014-10-28 20.00.00.png"
    And  stdout does not include "2014-10-27"
    And  stdout does not include "10.00.00"
    And  the recording program 'open' was invoked 0 times

  Scenario: Opening with Sketch
    Given the file "Screenshots/Screenshot 2001-01-01 01.01.01.png" "fake-screenshot"
    When I run "ss -s"
    Then stderr is empty
    And  the exit status is 0
    And  the recording program 'open' was invoked with ["-a", "Sketch.app", {{File.expand_path("Screenshots/Screenshot 2001-01-01 01.01.01.png").inspect}}]
    And  the recording program 'open' was invoked 1 time

  Scenario: Opening with preview
    Given the file "Screenshots/Screenshot 2001-01-01 01.01.01.png" "fake-screenshot"
    When I run "ss -o"
    Then stderr is empty
    And  the exit status is 0
    And  the recording program 'open' was invoked with [{{File.expand_path("Screenshots/Screenshot 2001-01-01 01.01.01.png").inspect}}]
    And  the recording program 'open' was invoked 1 time

  Scenario: Opening with Finder
    Given the file "Screenshots/Screenshot 2001-01-01 01.01.01.png" "fake-screenshot"
    When I run "ss -R"
    Then stderr is empty
    And  the exit status is 0
    And  the recording program 'open' was invoked with ["--reveal", {{File.expand_path("Screenshots/Screenshot 2001-01-01 01.01.01.png").inspect}}]
    And  the recording program 'open' was invoked 1 time

  Scenario: Ignores files that don't have the right format
  Scenario: When there are no screenshots

