### general settings
export XDG_CONFIG_HOME="$HOME/.config"

### homebrew settings
eval "$(/opt/homebrew/bin/brew shellenv)"

### vivid settings
export LS_COLORS="$(vivid generate dracula)"

### zsh settings
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
bindkey '`' autosuggest-accept
  if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
  fi

### zoxide settings
eval "$(zoxide init zsh)"

### eza settings
alias ls='eza --color=always --icons --group-directories-first'
alias la='eza --color=always --icons --group-directories-first --all'
alias ll='eza --color=always --icons --group-directories-first --all --long'
alias lt='eza --tree --color=always --icons --group-directories-first --all'

### fzf settings
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

export FZF_DEFAULT_OPTS='
--cycle
--height 40%
--layout=reverse
--border
--preview-window=right:60%:wrap
--preview "if [ -d {} ]; then eza --all --color=always --icons {}; else bat --style=numbers --color=always {}; fi"
'

export FZF_ALT_C_OPTS='
--preview "eza --all --color=always --icons {}"
'

### bat settings
export BAT_THEME=Dracula

### starship settings
export STARSHIP_CONFIG=~/.config/starship/config.toml
eval "$(starship init zsh)"

### lazygit settings
alias lg='lazygit'

### tmux settings
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tl='tmux ls'
alias tk='tmux kill-session -t'

## tealdeer settings
export TEALDEER_CONFIG_DIR="$HOME/.config/tealdeer"

### JAVA settings
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export ANDROID_HOME=/Users/bytedance/Library/Android/sdk
export ANDROID_AVD_HOME=/Users/bytedance/.android/avd
