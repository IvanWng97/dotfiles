<h1 align="center">Welcome to Evan's dotfiles 👋</h1>
💻 ghostty, neovim, fish/zsh, tmux, starship, lazygit, homebrew — my whole world
<div align="center">
<img width="720" alt="IMG_1059" src="https://user-images.githubusercontent.com/39482599/222035732-e245becc-dd67-4d42-8c8c-28a2592d4d13.png">
</div>

## Initial Setup and Installation

> All shell commands manage **globally installed packages** (Homebrew, npm, pipx, cargo, fisher, mas).

### Prerequisites

- macOS with [Homebrew](https://brew.sh)
- `git` (ships with the Xcode CLT) and a checkout of this repo at `$HOME`

### Workflows

| Command | What it does |
| --- | --- |
| `make install` | First-time bootstrap: installs everything from `Backup/Brewfile`, `Npmfile`, `Pipfile`, `Cargofile`, `Fishfile`, plus tpm + plugins. |
| `make update` | Upgrades brew/npm/pipx/cargo/fisher/mas/tmux packages and re-dumps `Backup/Brewfile` so it matches reality. |
| `make backup` | Re-dumps every package list into `Backup/` for committing. |

All three live in [`scripts/`](scripts) and share a small set of helpers (`set -euo pipefail`, per-tool guards, summary output for `update.sh`).

## Local Settings

### Shell

Two shells are configured side-by-side:
- [Fish](.config/fish/config.fish) with the abbreviations and helper functions I actually use day-to-day
- [Zsh](.zshrc), kept lean — eza/zoxide/fzf/bat/starship glue

[Starship](https://starship.rs) is the prompt for both — see [`config.toml`](.config/starship/config.toml).

### Editors

|                         | Vim        | Neovim                    |
| ----------------------- | ---------- | ------------------------- |
| Main Configuration File | `~/.vimrc` | `~/.config/nvim/init.lua` |
| Configuration directory | `~/.vim`   | `~/.config/nvim`          |

[Helix](.config/helix/config.toml) is also set up for quick edits.

### Multiplexer

Tmux config lives in [`tmux.conf`](.config/tmux/tmux.conf). Prefix is `C-Space`; `C-h/j/k/l` navigates panes (vim-aware), `M-h/j/k/l` resizes them. [Zellij](.config/zellij/config.kdl) is configured as an alternative.

### Terminals

Configs for [Ghostty](.config/ghostty/config), [Kitty](.config/kitty/kitty.conf), and [Alacritty](.config/alacritty/alacritty.toml) — Ghostty is the daily driver.

### Other tools

[lazygit](.config/lazygit/config.yml), [tealdeer](.config/tealdeer/config.toml), [lf](.config/lf/lfrc), [xplr](.config/xplr/init.lua).

### Color scheme

Everything is [Dracula](https://draculatheme.com)!

## Fonts

[JetBrains Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono) — installed via the `font-jetbrains-mono-nerd-font` cask in `Backup/Brewfile`.

## Author

👤 **Evan**

- Website: medium.com/navepnow
- Twitter: [@NavePnow](https://twitter.com/NavePnow)
- GitHub: [@NavePnow](https://github.com/NavePnow)

## Show your support

Give a ⭐️ if this project helped you!

<a href="https://www.patreon.com/NavePnow">
  <img src="https://c5.patreon.com/external/logo/become_a_patron_button@2x.png" width="160">
</a>
