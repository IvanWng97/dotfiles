if status is-interactive
    # Commands to run in interactive sessions can go here
end

# import other settings
source ~/.config/fish/private.fish

# general settings
fish_config theme choose Dracula
fish_add_path ~/.cargo/bin
fish_add_path /opt/homebrew/bin
set fish_cursor_insert line
set fish_cursor_replace_one underscore
# set fish_prompt_pwd_dir_length 0
set fish_greeting
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x EDITOR nvim
set -x LS_COLORS "$(vivid generate dracula)"
bind ` accept-autosuggestion
bind \co 'open .'
bind -M insert ` accept-autosuggestion
alias nv nvim
alias lg lazygit


# eza
alias ls "eza --color=always --icons --group-directories-first"
alias la 'eza --color=always --icons --group-directories-first --all'
alias ll 'eza --color=always --icons --group-directories-first --all --long'
alias lt 'eza --tree --color=always --icons --group-directories-first --all'

# tmux
abbr ta "tmux attach -t"
abbr tn "tmux new -s"
abbr tl "tmux ls"
abbr tk "tmux kill-session -t"

# zoxide
zoxide init fish | source

#starship
set -x STARSHIP_CONFIG "$HOME/.config/starship/config.toml"
starship init fish | source
enable_transience

# fzf
fzf_configure_bindings --git_status=\cg --git_log=\cl --history=\cr --variables=\cv --directory=\cf --processes=\cp
set fzf_preview_dir_cmd exa --all --color=always --icons
set fzf_fd_opts --hidden --no-ignore
set -x FZF_DEFAULT_OPTS --cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*" --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4

# bat
set -x BAT_THEME Dracula

# tealdeer
set -x TEALDEER_CONFIG_DIR "$HOME/.config/tealdeer"
