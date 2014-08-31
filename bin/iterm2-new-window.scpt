(* Makes a new iterm window and cds to the dir specified on argv
 * (for integration with https://github.com/karan/atom-terminal)
 *
 * Jesus, it takes fucking *hours* to figure out the simplest things (e.g. where are the fucking docs)
 *
 * I think this is the AS API https://developer.apple.com/library/mac/documentation/AppleScript/Conceptual/AppleScriptLangGuide/reference/ASLR_cmds.html
 * iTerm "api":               https://github.com/gnachman/iTerm2/blob/master/English.lproj/iTerm.scriptTerminology
 * iTerm applescript example: http://iterm.sourceforge.net/scripting.shtml
 * iTerm applescript example: https://gist.github.com/reyjrar/1769355
 *)
on run argv
  set dir to item 1 of argv

  tell application "iTerm"
    if it is not running
      activate
    end if

    set myterm to (make new terminal)
    tell myterm
      launch session "Default Session"
      -- this is dumb, I should be able to cd to the dir I want and launch from there
      tell the last session
        write text "cd " & dir
      end tell
    end tell
    activate

    tell application "Finder"
      set _bounds to bounds of window of desktop
    end tell
    set the bounds of the first window to _bounds
  end tell
end run



