# Load colors into shell for colored-man-pages.plugin.zsh
autoload -U colors && colors

# General options
setopt interactive_comments     # allow comments even in interactive shells.
unsetopt beep                   # don't bloody beep
unsetopt list_beep              # don't beep on ambiguous completions
unsetopt flow_control           # disable ^S/^Q flow control

# History options
setopt share_history            # share it across sessions
setopt extended_history         # add timestamps to history
setopt hist_ignore_dups         # don't record dupes in history
setopt hist_ignore_space        # remove command line from history list when first character on the line is a space
setopt hist_reduce_blanks       # remove superflous blanks
setopt hist_fcntl_lock          # lock history file

# Directory options
setopt auto_cd                  # type bare dir name and cd to it e.g. `$ /`

# Completions options
setopt complete_in_word         # don't move cursor to end of line on completion
unsetopt correct                # don't autocorrect spelling for args
unsetopt correct_all            # don't autocorrect spelling for args
unsetopt local_options          # allow funcs to have their own setopts (i.e. don't change globally)
unsetopt local_traps            # allow funcs to have their own signal trap opts (i.e. don't change globally)

# Process options
unsetopt bg_nice                # don't re-nice bg procs to lower priority
unsetopt hup                    # don't send the HUP signal to running jobs when the shell exits.
