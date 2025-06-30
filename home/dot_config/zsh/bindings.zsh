# use vi mode on zle
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode

# search backwards and forwards with a pattern
bindkey -M vicmd '/' history-incremental-pattern-search-backward
bindkey -M vicmd '?' history-incremental-pattern-search-forward

# set up for insert mode too
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^F' history-incremental-pattern-search-forward

# allow delete-char in vimcmd mode
bindkey -M viins '^[[3~' delete-char
bindkey -M vicmd '^[[3~' delete-char
bindkey -M viins "${terminfo[khome]/O/[}" beginning-of-line
bindkey -M viins "${terminfo[kend]/O/[}" end-of-line
bindkey -M vicmd "${terminfo[khome]/O/[}" beginning-of-line
bindkey -M vicmd "${terminfo[kend]/O/[}" end-of-line

# make UP and DOWN usable in history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
