(* Makes a new iterm window and cds to the dir specified on argv
 * (for integration with https://github.com/karan/atom-terminal)
 *
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
      set mysession to (make new session at the end of sessions)
      tell mysession
        exec command "/usr/local/bin/fish --login"
        write text "cd " & dir
      end tell
    end tell
    activate
  end tell
end run
