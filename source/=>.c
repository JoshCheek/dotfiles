// Compile from root with
// $ clang -Ofast -o bin/=\>  source/=\>.c
#include <unistd.h>

/* Another flaw with Shebang that would be nice to fix:
 *
 * Given the file "say_hello"
 *   #!/usr/bin/env => ruby -e 'puts "hello world!"'
 *
 * It will not respect the quotes (nor will it respect escapes, even though not shown here)
 * So argc will be 6, and argv will be (showing without quotes so its easier to see)
 *   [ /Users/josh/code/dotfiles/bin/=>,
 *     -e,
 *     'puts,       # Single quote did not cause it to keep the space
 *     "hello,      # Double quote did not cause it to keep the space
 *     world!"',
 *     ./say_hello
 *   ]
 *
 * Probably have to read the file in the last arg to get the real shebang
 * because we can't know how much whitespace was in there.
 */


int main(int argc, char *argv[]) {
  /* Given someprogram:
   *   #!/path/to/-> sometarget somearg
   *
   * When you run "someprogram", it will invoke "->" with argv of
   *   [ "/path/to/->",           # path to our program (ie you can see this in RbConfig.ruby)
   *     "sometarget",            # program we actually want to execute (specified in our shebang)
   *     "somearg",               # argument for sometarget (specified in our shebang)
   *     "/path/to/someprogram",  # path to program that executed the shebang (OS seems to add this when you use a shebang)
   *     NULL,                    # signals the array is done
   *   ]
   *
   * And argc will be 4 (it does not include the NULL)
   */

  // So skip path to current program to get target
  const char* target_program = argv[1];

  /* The target is expecting its argv[0] to be /path/to/sometarget and its argv[1] to be "somearg".
   * So we will pass it argv+1, making its argv
   *   [ "sometarget", "somearg", "/path/to/someprogram", NULL ]
   * And execvp will change that to
   *   [ "/path/to/sometarget", "somearg", "/path/to/someprogram", NULL ]
   */
  char *const *child_args = argv+1;

  /* So now chil'd argv is
   *   [ "/path/to/sometarget", "somearg", "/path/to/someprogram", NULL ]
   *
   * But we're using shebangs almost as if they were links with args,
   * sometarget isn't going to go run someprogram like a shebang,
   * rather someprogram has delegated itself entirely to sometarget.
   * this means we need to lose that trailing "/path/to/someprogram"
   * We'll do this by writing NULL at that location, which is how we
   * signal that there are no more elements in the array.
   *
   * Now, how do we find that location? We'll look at argc,
   * which has a value of 4 in our example, the index of the current NULL,
   * one index after the path to the shebanged file we want to remove.
   */
  argv[argc-1] = NULL;

  // And now the arguments are set up correctly, we can call the target program.
  execvp(target_program, child_args);
}
