# Set exports if fzf is installed
export FZF_DEFAULT_OPTS="--cycle --border=bold"
if command -v fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND="fd --type f"
fi
if [[ -r "$XDG_CONFIG_HOME/fzf/preview.sh" ]]; then
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview '$XDG_CONFIG_HOME/fzf/preview.sh {}'"
fi

if [[ -n "$ZSH_VERSION" ]]; then
  source <(fzf --zsh)
  compdef _gnu_generic fzf
elif [[ -n "$BASH_VERSION" && :$SHELLOPTS: =~ :(vi|emacs): ]]; then
  eval "$(fzf --bash)"
fi
