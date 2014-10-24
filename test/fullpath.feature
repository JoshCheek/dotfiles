Feature: fullpath
  It is often advantageous to have the fullpath of a file
  eg: `ln -s (fullpath existing_file) (fullpath new_file)`
  super useful b/c ln will otherwise be relative to your pwd, which is basically never ever what I've ever wanted ever

  Scenario: Receives relative paths, prints the fullpath
    When I run "fullpath path"
    Then stdout is exactly "{{pwd}}/path"

  Scenario: Paths can be passed on ARGV or stdin
    When I run "fullpath from-argv"
    Then stdout is exactly "{{pwd}}/from-argv"

    Given the stdin content "from-stdin"
    When I run "fullpath"
    Then stdout is exactly "{{pwd}}/from-stdin"

  Scenario: argv trumps stdin
    Given the stdin content "from-stdin"
    When I run "fullpath from-argv"
    Then stdout is exactly "{{pwd}}/from-argv"

  Scenario: When there is only one path, it does not print a trailing newline
    Given the stdin content:
    """
    from-stdin

    """
    When I run "fullpath"
    Then stdout is exactly "{{pwd}}/from-stdin"


  Scenario: When there are multiple paths, each gets a trailing newline
    When I run "fullpath from-argv1 from-argv2"
    Then stdout is exactly:
    """
    {{pwd}}/from-argv1
    {{pwd}}/from-argv2

    """

  Scenario: -c and --copy flags copy the output to the clipboard as well as printing it
    Given I previously copied "not-a"
    When I run "fullpath a -c"
    Then stdout is exactly "{{pwd}}/a"
    And the clipboard now contains "{{pwd}}/a"

  Scenario: Ignores blank lines
    When I run "fullpath a ''"
    Then stdout is exactly "{{pwd}}/a"

    Given the stdin content:
    """
    a

    b


    """
    When I run "fullpath"
    Then stdout is exactly:
    """
    {{pwd}}/a
    {{pwd}}/b

    """

