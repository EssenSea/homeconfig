function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting

end

starship init fish | source
# if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
#     cat ~/.cache/ags/user/generated/terminal/sequences.txt
# end

#alias pamcan=pacman

# function fish_prompt
#   set_color cyan; echo (pwd)
#   set_color green; echo '> '
# end
# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_tree_sitter_global_optspecs
	string join \n h/help V/version
end

function __fish_tree_sitter_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_tree_sitter_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_tree_sitter_using_subcommand
	set -l cmd (__fish_tree_sitter_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c tree-sitter -n "__fish_tree_sitter_needs_command" -s h -l help -d 'Print help'
complete -c tree-sitter -n "__fish_tree_sitter_needs_command" -s V -l version -d 'Print version'
complete -c tree-sitter -n "__fish_tree_sitter_needs_command" -f -a "init-config" -d 'Generate a default config file'
complete -c tree-sitter -n "__fish_tree_sitter_needs_command" -f -a "init" -d 'Initialize a grammar repository'
complete -c tree-sitter -n "__fish_tree_sitter_needs_command" -f -a "generate" -d 'Generate a parser'
complete -c tree-sitter -n "__fish_tree_sitter_needs_command" -f -a "build" -d 'Compile a parser'
complete -c tree-sitter -n "__fish_tree_sitter_needs_command" -f -a "parse" -d 'Parse files'
complete -c tree-sitter -n "__fish_tree_sitter_needs_command" -f -a "test" -d 'Run a parser\'s tests'
complete -c tree-sitter -n "__fish_tree_sitter_needs_command" -f -a "fuzz" -d 'Fuzz a parser'
complete -c tree-sitter -n "__fish_tree_sitter_needs_command" -f -a "query" -d 'Search files using a syntax tree query'
complete -c tree-sitter -n "__fish_tree_sitter_needs_command" -f -a "highlight" -d 'Highlight a file'
complete -c tree-sitter -n "__fish_tree_sitter_needs_command" -f -a "tags" -d 'Generate a list of tags'
complete -c tree-sitter -n "__fish_tree_sitter_needs_command" -f -a "playground" -d 'Start local playground for a parser in the browser'
complete -c tree-sitter -n "__fish_tree_sitter_needs_command" -f -a "dump-languages" -d 'Print info about all known language parsers'
complete -c tree-sitter -n "__fish_tree_sitter_needs_command" -f -a "complete" -d 'Generate shell completions'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand init-config" -s h -l help -d 'Print help'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand init" -s u -l update -d 'Update outdated files'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand init" -s h -l help -d 'Print help'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand generate" -l abi -d 'Select the language ABI version to generate (default 14). Use --abi=latest to generate the newest supported version (14).' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand generate" -l libdir -d 'The path to the directory containing the parser library' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand generate" -l report-states-for-rule -d 'Produce a report of the states for the given rule, use `-` to report every rule' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand generate" -l js-runtime -d 'The name or path of the JavaScript runtime to use for generating parsers' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand generate" -s l -l log -d 'Show debug log during generation'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand generate" -l no-bindings -d 'Deprecated (no-op)'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand generate" -s b -l build -d 'Compile all defined languages in the current dir'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand generate" -s 0 -l debug-build -d 'Compile a parser in debug mode'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand generate" -s h -l help -d 'Print help'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand build" -s o -l output -d 'The path to output the compiled file' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand build" -s w -l wasm -d 'Build a WASM module instead of a dynamic library'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand build" -s d -l docker -d 'Run emscripten via docker even if it is installed locally (only if building a WASM module with --wasm)'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand build" -l reuse-allocator -d 'Make the parser reuse the same allocator as the library'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand build" -s 0 -l debug -d 'Compile a parser in debug mode'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand build" -s h -l help -d 'Print help'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -l paths -d 'The path to a file with paths to source file(s)' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -l scope -d 'Select a language by the scope instead of a file extension' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -l timeout -d 'Interrupt the parsing process by timeout (µs)' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -l edits -d 'Apply edits in the format: "row, col delcount insert_text"' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -l encoding -d 'The encoding of the input files' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -l config-path -d 'The path to an alternative config.json file' -r -F
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -s n -l test-number -d 'Parse the contents of a specific test' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -s d -l debug -d 'Show parsing debug log'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -s 0 -l debug-build -d 'Compile a parser in debug mode'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -s D -l debug-graph -d 'Produce the log.html file with debug graphs'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -l wasm -d 'Compile parsers to wasm instead of native dynamic libraries'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -l dot -d 'Output the parse data with graphviz dot'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -s x -l xml -d 'Output the parse data in XML format'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -s s -l stat -d 'Show parsing statistic'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -s t -l time -d 'Measure execution time'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -s q -l quiet -d 'Suppress main output'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -l open-log -d 'Open `log.html` in the default browser, if `--debug-graph` is supplied'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -s r -l rebuild -d 'Force rebuild the parser'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -l no-ranges -d 'Omit ranges in the output'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand parse" -s h -l help -d 'Print help'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand test" -s i -l include -d 'Only run corpus test cases whose name matches the given regex' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand test" -s e -l exclude -d 'Only run corpus test cases whose name does not match the given regex' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand test" -l config-path -d 'The path to an alternative config.json file' -r -F
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand test" -s u -l update -d 'Update all syntax trees in corpus files with current parser output'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand test" -s d -l debug -d 'Show parsing debug log'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand test" -s 0 -l debug-build -d 'Compile a parser in debug mode'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand test" -s D -l debug-graph -d 'Produce the log.html file with debug graphs'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand test" -l wasm -d 'Compile parsers to wasm instead of native dynamic libraries'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand test" -l open-log -d 'Open `log.html` in the default browser, if `--debug-graph` is supplied'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand test" -l show-fields -d 'Force showing fields in test diffs'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand test" -s r -l rebuild -d 'Force rebuild the parser'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand test" -l overview-only -d 'Show only the pass-fail overview tree'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand test" -s h -l help -d 'Print help'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand fuzz" -s s -l skip -d 'List of test names to skip' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand fuzz" -l subdir -d 'Subdirectory to the language' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand fuzz" -l edits -d 'Maximum number of edits to perform per fuzz test' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand fuzz" -l iterations -d 'Number of fuzzing iterations to run per test' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand fuzz" -s i -l include -d 'Only fuzz corpus test cases whose name matches the given regex' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand fuzz" -s e -l exclude -d 'Only fuzz corpus test cases whose name does not match the given regex' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand fuzz" -l log-graphs -d 'Enable logging of graphs and input'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand fuzz" -s l -l log -d 'Enable parser logging'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand fuzz" -s r -l rebuild -d 'Force rebuild the parser'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand fuzz" -s h -l help -d 'Print help'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand query" -l paths -d 'The path to a file with paths to source file(s)' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand query" -l byte-range -d 'The range of byte offsets in which the query will be executed' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand query" -l row-range -d 'The range of rows in which the query will be executed' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand query" -l scope -d 'Select a language by the scope instead of a file extension' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand query" -l config-path -d 'The path to an alternative config.json file' -r -F
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand query" -s t -l time -d 'Measure execution time'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand query" -s q -l quiet -d 'Suppress main output'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand query" -s c -l captures -d 'Order by captures instead of matches'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand query" -l test -d 'Whether to run query tests or not'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand query" -s h -l help -d 'Print help'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand highlight" -l captures-path -d 'The path to a file with captures' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand highlight" -l query-paths -d 'The paths to files with queries' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand highlight" -l scope -d 'Select a language by the scope instead of a file extension' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand highlight" -l paths -d 'The path to a file with paths to source file(s)' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand highlight" -l config-path -d 'The path to an alternative config.json file' -r -F
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand highlight" -s H -l html -d 'Generate highlighting as an HTML document'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand highlight" -l check -d 'Check that highlighting captures conform strictly to standards'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand highlight" -s t -l time -d 'Measure execution time'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand highlight" -s q -l quiet -d 'Suppress main output'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand highlight" -s h -l help -d 'Print help'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand tags" -l scope -d 'Select a language by the scope instead of a file extension' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand tags" -l paths -d 'The path to a file with paths to source file(s)' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand tags" -l config-path -d 'The path to an alternative config.json file' -r -F
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand tags" -s t -l time -d 'Measure execution time'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand tags" -s q -l quiet -d 'Suppress main output'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand tags" -s h -l help -d 'Print help'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand playground" -l grammar-path -d 'Path to the directory containing the grammar and wasm files' -r
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand playground" -s q -l quiet -d 'Don\'t open in default browser'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand playground" -s h -l help -d 'Print help'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand dump-languages" -l config-path -d 'The path to an alternative config.json file' -r -F
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand dump-languages" -s h -l help -d 'Print help'
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand complete" -s s -l shell -d 'The shell to generate completions for' -r -f -a "{bash\t'',elvish\t'',fish\t'',powershell\t'',zsh\t''}"
complete -c tree-sitter -n "__fish_tree_sitter_using_subcommand complete" -s h -l help -d 'Print help'
# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd
    builtin pwd -L
end

# A copy of fish's internal cd function. This makes it possible to use
# `alias cd=z` without causing an infinite loop.
if ! builtin functions --query __zoxide_cd_internal
    string replace --regex -- '^function cd\s' 'function __zoxide_cd_internal ' <$__fish_data_dir/functions/cd.fish | source
end

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd
    if set -q __zoxide_loop
        builtin echo "zoxide: infinite loop detected"
        builtin echo "Avoid aliasing `cd` to `z` directly, use `zoxide init --cmd=cd fish` instead"
        return 1
    end
    __zoxide_loop=1 __zoxide_cd_internal $argv
end

# =============================================================================
#
# Hook configuration for zoxide.
#

# Initialize hook to add new entries to the database.
function __zoxide_hook --on-variable PWD
    test -z "$fish_private_mode"
    and command zoxide add -- (__zoxide_pwd)
end

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

# Jump to a directory using only keywords.
function __zoxide_z
    set -l argc (builtin count $argv)
    if test $argc -eq 0
        __zoxide_cd $HOME
    else if test "$argv" = -
        __zoxide_cd -
    else if test $argc -eq 1 -a -d $argv[1]
        __zoxide_cd $argv[1]
    else if test $argc -eq 2 -a $argv[1] = --
        __zoxide_cd -- $argv[2]
    else
        set -l result (command zoxide query --exclude (__zoxide_pwd) -- $argv)
        and __zoxide_cd $result
    end
end

# Completions.
function __zoxide_z_complete
    set -l tokens (builtin commandline --current-process --tokenize)
    set -l curr_tokens (builtin commandline --cut-at-cursor --current-process --tokenize)

    if test (builtin count $tokens) -le 2 -a (builtin count $curr_tokens) -eq 1
        # If there are < 2 arguments, use `cd` completions.
        complete --do-complete "'' "(builtin commandline --cut-at-cursor --current-token) | string match --regex -- '.*/$'
    else if test (builtin count $tokens) -eq (builtin count $curr_tokens)
        # If the last argument is empty, use interactive selection.
        set -l query $tokens[2..-1]
        set -l result (command zoxide query --exclude (__zoxide_pwd) --interactive -- $query)
        and __zoxide_cd $result
        and builtin commandline --function cancel-commandline repaint
    end
end
complete --command __zoxide_z --no-files --arguments '(__zoxide_z_complete)'

# Jump to a directory using interactive search.
function __zoxide_zi
    set -l result (command zoxide query --interactive -- $argv)
    and __zoxide_cd $result
end

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

abbr --erase z &>/dev/null
alias z=__zoxide_z

abbr --erase zi &>/dev/null
alias zi=__zoxide_zi

# =============================================================================
#
# To initialize zoxide, add this to your configuration (usually
# ~/.config/fish/config.fish):
#
#   zoxide init fish | source
# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.

function __fish_niri_global_optspecs
	string join \n c/config= session h/help V/version
end

function __fish_niri_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_niri_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_niri_using_subcommand
	set -l cmd (__fish_niri_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c niri -n "__fish_niri_needs_command" -s c -l config -d 'Path to config file (default: `$XDG_CONFIG_HOME/niri/config.kdl`)' -r -F
complete -c niri -n "__fish_niri_needs_command" -l session -d 'Import environment globally to systemd and D-Bus, run D-Bus services'
complete -c niri -n "__fish_niri_needs_command" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c niri -n "__fish_niri_needs_command" -s V -l version -d 'Print version'
complete -c niri -n "__fish_niri_needs_command" -a "msg" -d 'Communicate with the running niri instance'
complete -c niri -n "__fish_niri_needs_command" -a "validate" -d 'Validate the config file'
complete -c niri -n "__fish_niri_needs_command" -a "panic" -d 'Cause a panic to check if the backtraces are good'
complete -c niri -n "__fish_niri_needs_command" -a "completions" -d 'Generate shell completions'
complete -c niri -n "__fish_niri_needs_command" -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -s j -l json -d 'Format output as JSON'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -f -a "outputs" -d 'List connected outputs'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -f -a "workspaces" -d 'List workspaces'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -f -a "windows" -d 'List open windows'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -f -a "layers" -d 'List open layer-shell surfaces'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -f -a "keyboard-layouts" -d 'Get the configured keyboard layouts'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -f -a "focused-output" -d 'Print information about the focused output'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -f -a "focused-window" -d 'Print information about the focused window'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -f -a "pick-window" -d 'Pick a window with the mouse and print information about it'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -f -a "pick-color" -d 'Pick a color from the screen with the mouse'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -f -a "action" -d 'Perform an action'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -f -a "output" -d 'Change output configuration temporarily'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -f -a "event-stream" -d 'Start continuously receiving events from the compositor'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -f -a "version" -d 'Print the version of the running niri instance'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -f -a "request-error" -d 'Request an error from the running niri instance'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -f -a "overview-state" -d 'Print the overview state'
complete -c niri -n "__fish_niri_using_subcommand msg; and not __fish_seen_subcommand_from outputs workspaces windows layers keyboard-layouts focused-output focused-window pick-window pick-color action output event-stream version request-error overview-state help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from outputs" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from workspaces" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from windows" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from layers" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from keyboard-layouts" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from focused-output" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from focused-window" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from pick-window" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from pick-color" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "quit" -d 'Exit niri'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "power-off-monitors" -d 'Power off all monitors via DPMS'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "power-on-monitors" -d 'Power on all monitors via DPMS'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "spawn" -d 'Spawn a command'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "spawn-sh" -d 'Spawn a command through the shell'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "do-screen-transition" -d 'Do a screen transition'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "screenshot" -d 'Open the screenshot UI'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "screenshot-screen" -d 'Screenshot the focused screen'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "screenshot-window" -d 'Screenshot the focused window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "toggle-keyboard-shortcuts-inhibit" -d 'Enable or disable the keyboard shortcuts inhibitor (if any) for the focused surface'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "close-window" -d 'Close the focused window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "fullscreen-window" -d 'Toggle fullscreen on the focused window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "toggle-windowed-fullscreen" -d 'Toggle windowed (fake) fullscreen on the focused window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window" -d 'Focus a window by id'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window-in-column" -d 'Focus a window in the focused column by index'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window-previous" -d 'Focus the previously focused window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-column-left" -d 'Focus the column to the left'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-column-right" -d 'Focus the column to the right'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-column-first" -d 'Focus the first column'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-column-last" -d 'Focus the last column'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-column-right-or-first" -d 'Focus the next column to the right, looping if at end'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-column-left-or-last" -d 'Focus the next column to the left, looping if at start'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-column" -d 'Focus a column by index'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window-or-monitor-up" -d 'Focus the window or the monitor above'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window-or-monitor-down" -d 'Focus the window or the monitor below'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-column-or-monitor-left" -d 'Focus the column or the monitor to the left'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-column-or-monitor-right" -d 'Focus the column or the monitor to the right'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window-down" -d 'Focus the window below'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window-up" -d 'Focus the window above'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window-down-or-column-left" -d 'Focus the window below or the column to the left'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window-down-or-column-right" -d 'Focus the window below or the column to the right'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window-up-or-column-left" -d 'Focus the window above or the column to the left'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window-up-or-column-right" -d 'Focus the window above or the column to the right'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window-or-workspace-down" -d 'Focus the window or the workspace below'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window-or-workspace-up" -d 'Focus the window or the workspace above'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window-top" -d 'Focus the topmost window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window-bottom" -d 'Focus the bottommost window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window-down-or-top" -d 'Focus the window below or the topmost window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-window-up-or-bottom" -d 'Focus the window above or the bottommost window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-left" -d 'Move the focused column to the left'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-right" -d 'Move the focused column to the right'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-to-first" -d 'Move the focused column to the start of the workspace'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-to-last" -d 'Move the focused column to the end of the workspace'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-left-or-to-monitor-left" -d 'Move the focused column to the left or to the monitor to the left'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-right-or-to-monitor-right" -d 'Move the focused column to the right or to the monitor to the right'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-to-index" -d 'Move the focused column to a specific index on its workspace'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-window-down" -d 'Move the focused window down in a column'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-window-up" -d 'Move the focused window up in a column'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-window-down-or-to-workspace-down" -d 'Move the focused window down in a column or to the workspace below'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-window-up-or-to-workspace-up" -d 'Move the focused window up in a column or to the workspace above'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "consume-or-expel-window-left" -d 'Consume or expel the focused window left'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "consume-or-expel-window-right" -d 'Consume or expel the focused window right'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "consume-window-into-column" -d 'Consume the window to the right into the focused column'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "expel-window-from-column" -d 'Expel the focused window from the column'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "swap-window-right" -d 'Swap focused window with one to the right'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "swap-window-left" -d 'Swap focused window with one to the left'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "toggle-column-tabbed-display" -d 'Toggle the focused column between normal and tabbed display'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "set-column-display" -d 'Set the display mode of the focused column'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "center-column" -d 'Center the focused column on the screen'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "center-window" -d 'Center the focused window on the screen'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "center-visible-columns" -d 'Center all fully visible columns on the screen'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-workspace-down" -d 'Focus the workspace below'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-workspace-up" -d 'Focus the workspace above'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-workspace" -d 'Focus a workspace by reference (index or name)'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-workspace-previous" -d 'Focus the previous workspace'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-window-to-workspace-down" -d 'Move the focused window to the workspace below'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-window-to-workspace-up" -d 'Move the focused window to the workspace above'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-window-to-workspace" -d 'Move the focused window to a workspace by reference (index or name)'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-to-workspace-down" -d 'Move the focused column to the workspace below'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-to-workspace-up" -d 'Move the focused column to the workspace above'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-to-workspace" -d 'Move the focused column to a workspace by reference (index or name)'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-workspace-down" -d 'Move the focused workspace down'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-workspace-up" -d 'Move the focused workspace up'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-workspace-to-index" -d 'Move the focused workspace to a specific index on its monitor'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "set-workspace-name" -d 'Set the name of the focused workspace'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "unset-workspace-name" -d 'Unset the name of the focused workspace'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-monitor-left" -d 'Focus the monitor to the left'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-monitor-right" -d 'Focus the monitor to the right'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-monitor-down" -d 'Focus the monitor below'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-monitor-up" -d 'Focus the monitor above'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-monitor-previous" -d 'Focus the previous monitor'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-monitor-next" -d 'Focus the next monitor'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-monitor" -d 'Focus a monitor by name'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-window-to-monitor-left" -d 'Move the focused window to the monitor to the left'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-window-to-monitor-right" -d 'Move the focused window to the monitor to the right'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-window-to-monitor-down" -d 'Move the focused window to the monitor below'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-window-to-monitor-up" -d 'Move the focused window to the monitor above'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-window-to-monitor-previous" -d 'Move the focused window to the previous monitor'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-window-to-monitor-next" -d 'Move the focused window to the next monitor'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-window-to-monitor" -d 'Move the focused window to a specific monitor'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-to-monitor-left" -d 'Move the focused column to the monitor to the left'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-to-monitor-right" -d 'Move the focused column to the monitor to the right'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-to-monitor-down" -d 'Move the focused column to the monitor below'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-to-monitor-up" -d 'Move the focused column to the monitor above'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-to-monitor-previous" -d 'Move the focused column to the previous monitor'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-to-monitor-next" -d 'Move the focused column to the next monitor'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-column-to-monitor" -d 'Move the focused column to a specific monitor'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "set-window-width" -d 'Change the width of the focused window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "set-window-height" -d 'Change the height of the focused window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "reset-window-height" -d 'Reset the height of the focused window back to automatic'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "switch-preset-column-width" -d 'Switch between preset column widths'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "switch-preset-column-width-back" -d 'Switch between preset column widths backwards'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "switch-preset-window-width" -d 'Switch between preset window widths'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "switch-preset-window-width-back" -d 'Switch between preset window widths backwards'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "switch-preset-window-height" -d 'Switch between preset window heights'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "switch-preset-window-height-back" -d 'Switch between preset window heights backwards'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "maximize-column" -d 'Toggle the maximized state of the focused column'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "set-column-width" -d 'Change the width of the focused column'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "expand-column-to-available-width" -d 'Expand the focused column to space not taken up by other fully visible columns'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "switch-layout" -d 'Switch between keyboard layouts'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "show-hotkey-overlay" -d 'Show the hotkey overlay'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-workspace-to-monitor-left" -d 'Move the focused workspace to the monitor to the left'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-workspace-to-monitor-right" -d 'Move the focused workspace to the monitor to the right'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-workspace-to-monitor-down" -d 'Move the focused workspace to the monitor below'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-workspace-to-monitor-up" -d 'Move the focused workspace to the monitor above'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-workspace-to-monitor-previous" -d 'Move the focused workspace to the previous monitor'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-workspace-to-monitor-next" -d 'Move the focused workspace to the next monitor'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-workspace-to-monitor" -d 'Move the focused workspace to a specific monitor'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "toggle-debug-tint" -d 'Toggle a debug tint on windows'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "debug-toggle-opaque-regions" -d 'Toggle visualization of render element opaque regions'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "debug-toggle-damage" -d 'Toggle visualization of output damage'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "toggle-window-floating" -d 'Move the focused window between the floating and the tiling layout'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-window-to-floating" -d 'Move the focused window to the floating layout'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-window-to-tiling" -d 'Move the focused window to the tiling layout'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-floating" -d 'Switches focus to the floating layout'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "focus-tiling" -d 'Switches focus to the tiling layout'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "switch-focus-between-floating-and-tiling" -d 'Toggles the focus between the floating and the tiling layout'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "move-floating-window" -d 'Move the floating window on screen'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "toggle-window-rule-opacity" -d 'Toggle the opacity of the focused window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "set-dynamic-cast-window" -d 'Set the dynamic cast target to the focused window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "set-dynamic-cast-monitor" -d 'Set the dynamic cast target to the focused monitor'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "clear-dynamic-cast-target" -d 'Clear the dynamic cast target, making it show nothing'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "toggle-overview" -d 'Toggle (open/close) the Overview'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "open-overview" -d 'Open the Overview'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "close-overview" -d 'Close the Overview'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "toggle-window-urgent" -d 'Toggle urgent status of a window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "set-window-urgent" -d 'Set urgent status of a window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "unset-window-urgent" -d 'Unset urgent status of a window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "load-config-file" -d 'Reload the config file'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from action" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from output" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from output" -a "off" -d 'Turn off the output'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from output" -a "on" -d 'Turn on the output'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from output" -a "mode" -d 'Set the output mode'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from output" -a "scale" -d 'Set the output scale'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from output" -a "transform" -d 'Set the output transform'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from output" -a "position" -d 'Set the output position'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from output" -a "vrr" -d 'Set the variable refresh rate mode'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from output" -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from event-stream" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from version" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from request-error" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from overview-state" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from help" -f -a "outputs" -d 'List connected outputs'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from help" -f -a "workspaces" -d 'List workspaces'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from help" -f -a "windows" -d 'List open windows'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from help" -f -a "layers" -d 'List open layer-shell surfaces'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from help" -f -a "keyboard-layouts" -d 'Get the configured keyboard layouts'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from help" -f -a "focused-output" -d 'Print information about the focused output'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from help" -f -a "focused-window" -d 'Print information about the focused window'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from help" -f -a "pick-window" -d 'Pick a window with the mouse and print information about it'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from help" -f -a "pick-color" -d 'Pick a color from the screen with the mouse'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from help" -f -a "action" -d 'Perform an action'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from help" -f -a "output" -d 'Change output configuration temporarily'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from help" -f -a "event-stream" -d 'Start continuously receiving events from the compositor'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from help" -f -a "version" -d 'Print the version of the running niri instance'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from help" -f -a "request-error" -d 'Request an error from the running niri instance'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from help" -f -a "overview-state" -d 'Print the overview state'
complete -c niri -n "__fish_niri_using_subcommand msg; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c niri -n "__fish_niri_using_subcommand validate" -s c -l config -d 'Path to config file (default: `$XDG_CONFIG_HOME/niri/config.kdl`)' -r -F
complete -c niri -n "__fish_niri_using_subcommand validate" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c niri -n "__fish_niri_using_subcommand panic" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand completions" -s h -l help -d 'Print help'
complete -c niri -n "__fish_niri_using_subcommand help; and not __fish_seen_subcommand_from msg validate panic completions help" -f -a "msg" -d 'Communicate with the running niri instance'
complete -c niri -n "__fish_niri_using_subcommand help; and not __fish_seen_subcommand_from msg validate panic completions help" -f -a "validate" -d 'Validate the config file'
complete -c niri -n "__fish_niri_using_subcommand help; and not __fish_seen_subcommand_from msg validate panic completions help" -f -a "panic" -d 'Cause a panic to check if the backtraces are good'
complete -c niri -n "__fish_niri_using_subcommand help; and not __fish_seen_subcommand_from msg validate panic completions help" -f -a "completions" -d 'Generate shell completions'
complete -c niri -n "__fish_niri_using_subcommand help; and not __fish_seen_subcommand_from msg validate panic completions help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c niri -n "__fish_niri_using_subcommand help; and __fish_seen_subcommand_from msg" -f -a "outputs" -d 'List connected outputs'
complete -c niri -n "__fish_niri_using_subcommand help; and __fish_seen_subcommand_from msg" -f -a "workspaces" -d 'List workspaces'
complete -c niri -n "__fish_niri_using_subcommand help; and __fish_seen_subcommand_from msg" -f -a "windows" -d 'List open windows'
complete -c niri -n "__fish_niri_using_subcommand help; and __fish_seen_subcommand_from msg" -f -a "layers" -d 'List open layer-shell surfaces'
complete -c niri -n "__fish_niri_using_subcommand help; and __fish_seen_subcommand_from msg" -f -a "keyboard-layouts" -d 'Get the configured keyboard layouts'
complete -c niri -n "__fish_niri_using_subcommand help; and __fish_seen_subcommand_from msg" -f -a "focused-output" -d 'Print information about the focused output'
complete -c niri -n "__fish_niri_using_subcommand help; and __fish_seen_subcommand_from msg" -f -a "focused-window" -d 'Print information about the focused window'
complete -c niri -n "__fish_niri_using_subcommand help; and __fish_seen_subcommand_from msg" -f -a "pick-window" -d 'Pick a window with the mouse and print information about it'
complete -c niri -n "__fish_niri_using_subcommand help; and __fish_seen_subcommand_from msg" -f -a "pick-color" -d 'Pick a color from the screen with the mouse'
complete -c niri -n "__fish_niri_using_subcommand help; and __fish_seen_subcommand_from msg" -f -a "action" -d 'Perform an action'
complete -c niri -n "__fish_niri_using_subcommand help; and __fish_seen_subcommand_from msg" -f -a "output" -d 'Change output configuration temporarily'
complete -c niri -n "__fish_niri_using_subcommand help; and __fish_seen_subcommand_from msg" -f -a "event-stream" -d 'Start continuously receiving events from the compositor'
complete -c niri -n "__fish_niri_using_subcommand help; and __fish_seen_subcommand_from msg" -f -a "version" -d 'Print the version of the running niri instance'
complete -c niri -n "__fish_niri_using_subcommand help; and __fish_seen_subcommand_from msg" -f -a "request-error" -d 'Request an error from the running niri instance'
complete -c niri -n "__fish_niri_using_subcommand help; and __fish_seen_subcommand_from msg" -f -a "overview-state" -d 'Print the overview state'
