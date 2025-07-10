# Setup completion for for custom commands
fpath+="$HOME/.config/zsh/completions"

# Prerequisites for macos
if [[ $(uname) == "Darwin" ]]; then
  if command -v brew &> /dev/null; then
    path+="/opt/homebrew/share/zsh/site-functions"
    fpath+="/opt/homebrew/share/zsh/site-functions"
  fi
fi

path+="$HOME/.config/zsh/plugins/zsh-autosuggestions"
fpath+="$HOME/.config/zsh/plugins/zsh-autosuggestions"
path+="$HOME/.config/zsh/plugins/zsh-history-substring-search"
fpath+="$HOME/.config/zsh/plugins/zsh-history-substring-search"
path+="$HOME/.config/zsh/plugins/zsh-syntax-highlighting"
fpath+="$HOME/.config/zsh/plugins/zsh-syntax-highlighting"
path+="$HOME/.config/zsh/plugins/zsh-completions"
fpath+="$HOME/.config/zsh/plugins/zsh-completions"
path+="$HOME/.config/zsh/plugins/collored-man-pages"
fpath+="$HOME/.config/zsh/plugins/collored-man-pages"
path+="$HOME/.config/zsh/plugins/sudo"
fpath+="$HOME/.config/zsh/plugins/sudo"
path+="$HOME/.config/zsh/plugins/powerlevel10k"
fpath+="$HOME/.config/zsh/plugins/powerlevel10k"
path+="$HOME/.config/zsh/plugins/powerlevel10k-config"
fpath+="$HOME/.config/zsh/plugins/powerlevel10k-config"

# Oh-My-Zsh/Prezto calls compinit during initialization,
# calling it twice causes slight start up slowdown
# as all $fpath entries will be traversed again.
# Export different completion directory
export ZSH_COMPLETION_DUMP=$XDG_STATE_HOME/zsh/zcompdump
mkdir -p "$(dirname "$ZSH_COMPLETION_DUMP")"
autoload -Uz compinit
for dump in $ZSH_COMPLETION_DUMP(N.mh+24); do
  compinit -d $ZSH_COMPLETION_DUMP
done
compinit -d $ZSH_COMPLETION_DUMP -C

if [[ -f "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" ]]; then
  source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
fi
if [[ -f "$HOME/.config/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh" ]]; then
  source "$HOME/.config/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh"
fi
if [[ -f "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh" ]]; then
  source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
fi
if [[ -f "$HOME/.config/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh" ]]; then
  source "$HOME/.config/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh"
fi
if [[ -f "$HOME/.config/zsh/plugins/collored-man-pages/collored-man-pages.plugin.zsh" ]]; then
  source "$HOME/.config/zsh/plugins/collored-man-pages/collored-man-pages.plugin.zsh"
fi
if [[ -f "$HOME/.config/zsh/plugins/sudo/sudo.plugin.zsh" ]]; then
  source "$HOME/.config/zsh/plugins/sudo/sudo.plugin.zsh"
fi
if [[ -f "$HOME/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$HOME/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme"
fi
if [[ -f "$HOME/.config/zsh/plugins/powerlevel10k-config/p10k.zsh" ]]; then
  source "$HOME/.config/zsh/plugins/powerlevel10k-config/p10k.zsh"
fi

# Source plugins installed from other tools like eza, mcfly etc.
if [[ -d "$XDG_CONFIG_HOME"/zsh/plugins ]]; then
  # shellcheck disable=SC2044
  for file in $(find "$XDG_CONFIG_HOME"/zsh/plugins/ -maxdepth 1 \( -type f -o -type l \) \( -iname "*.sh" -o -iname "*.zsh" \)); do
    # shellcheck source=/dev/null
    source "$file"
  done
fi
