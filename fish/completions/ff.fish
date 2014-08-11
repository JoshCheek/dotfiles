set all_completions (ff --help | ruby -r shellwords -ne '
  (/^\s*--(?<flagname>\S+)\s*?(?<arg>\w+)?\s*?# (?<desc>.*)$/ =~ $_) && (
    arg = (arg ? " --require-parameter" : "--no-files")
    puts("--command ff --long #{flagname}#{" -r" if arg} --description #{desc.shellescape}")
  )
')
for completion_argstring in $all_completions
  eval "complete $completion_argstring" # Again having to use eval, why is it so hard to work with strings? this is frustrating :(
end
