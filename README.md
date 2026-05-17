<h1 align="center">Welcome to Evan's dotfiles 👋</h1>
💻 ghostty, neovim, fish/zsh, tmux, starship, lazygit, homebrew — my whole world
<div align="center">
<img width="720" alt="IMG_1059" src="https://user-images.githubusercontent.com/39482599/222035732-e245becc-dd67-4d42-8c8c-28a2592d4d13.png">
</div>

## Initial Setup and Installation

> All shell commands manage **globally installed packages** (Homebrew, npm, pipx, cargo, fisher, mas).

The repo lives at `~/dotfiles/` and uses [GNU stow](https://www.gnu.org/software/stow/) to symlink each package into `$HOME` — `$HOME` itself is not a git working tree.

### Fresh Mac

```sh
xcode-select --install        # one-time, GUI prompt
git clone https://github.com/IvanWng97/dotfiles.git ~/dotfiles
cd ~/dotfiles && make bootstrap
```

`make bootstrap` installs Homebrew + stow, backs up any conflicting files in `$HOME` to `~/.dotfiles-pre-stow-<timestamp>/`, stows the dotfile packages, and runs `make install`. Pass `SKIP_INSTALL=1` to skip the package install step.

### Workflows

| Command | What it does |
| --- | --- |
| `make bootstrap` | Fresh-machine setup: brew + stow + symlinks + `make install`. Idempotent. |
| `make install` | Installs everything from `Backup/Brewfile`, `Npmfile`, `Pipfile`, `Cargofile`, `Fishfile`, plus tpm + plugins. |
| `make install-links` | Re-run `stow` to (re)create symlinks under `$HOME`. |
| `make uninstall-links` | Remove the symlinks (configs stay safe in `~/dotfiles/`). |
| `make relink` | `uninstall-links` then `install-links` — useful after adding a new file to a package. |
| `make update` | Upgrades brew/npm/pipx/cargo/fisher/mas/tmux packages and re-dumps `Backup/Brewfile` so it matches reality. |
| `make backup` | Re-dumps every package list into `Backup/` for committing. |

All four scripts live in [`scripts/`](scripts) and share a small set of helpers (`set -euo pipefail`, per-tool guards, summary output for `update.sh`).

### Stow packages

Each top-level directory is a stow package:

| Package | Symlinks into |
| --- | --- |
| `aria2/` | `~/.aria2/aria2.conf` |
| `bash/` | `~/.bashrc` |
| `claude/` | `~/.claude/settings.json` |
| `config/` | `~/.config/{alacritty,fish,ghostty,helix,kitty,lazygit,lf,starship,tealdeer,tmux,xplr,zellij,git}/...` |
| `czrc/` | `~/.czrc` |
| `vim/` | `~/.vimrc`, `~/.ideavimrc` |
| `zsh/` | `~/.zshrc` |

## Local Settings

### Shell

Two shells are configured side-by-side:
- [Fish](config/.config/fish/config.fish) with the abbreviations and helper functions I actually use day-to-day
- [Zsh](zsh/.zshrc), kept lean — eza/zoxide/fzf/bat/starship glue

[Starship](https://starship.rs) is the prompt for both — see [`config.toml`](config/.config/starship/config.toml).

### Editors

|                         | Vim        | Neovim                    |
| ----------------------- | ---------- | ------------------------- |
| Main Configuration File | `~/.vimrc` | `~/.config/nvim/init.lua` |
| Configuration directory | `~/.vim`   | `~/.config/nvim`          |

[Helix](config/.config/helix/config.toml) is also set up for quick edits.

### Multiplexer

Tmux config lives in [`tmux.conf`](config/.config/tmux/tmux.conf). Prefix is `C-Space`; `C-h/j/k/l` navigates panes (vim-aware), `M-h/j/k/l` resizes them. [Zellij](config/.config/zellij/config.kdl) is configured as an alternative.

### Terminals

Configs for [Ghostty](config/.config/ghostty/config), [Kitty](config/.config/kitty/kitty.conf), and [Alacritty](config/.config/alacritty/alacritty.toml) — Ghostty is the daily driver.

### Other tools

[lazygit](config/.config/lazygit/config.yml), [tealdeer](config/.config/tealdeer/config.toml), [lf](config/.config/lf/lfrc), [xplr](config/.config/xplr/init.lua), [helix](config/.config/helix/config.toml).

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
