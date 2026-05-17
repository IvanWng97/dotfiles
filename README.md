<h1 align="center">Welcome to Ivan's dotfiles 👋</h1>
💻 ghostty, neovim, zsh, tmux, starship, lazygit, homebrew — my whole world
<div align="center">
<img width="720" alt="IMG_1059" src="https://user-images.githubusercontent.com/39482599/222035732-e245becc-dd67-4d42-8c8c-28a2592d4d13.png">
</div>

## Initial Setup and Installation

> All shell commands manage **globally installed packages** (Homebrew, npm, pipx, cargo, mas).

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
| `make symlinks-check` | Verify every package file has a matching, correctly-resolved symlink in `$HOME`; reports orphans too. Exits non-zero on issues. |
| `make update` | Upgrades brew/npm/pipx/cargo/mas/tmux packages and re-dumps `Backup/Brewfile` so it matches reality. |
| `make backup` | Re-dumps every package list into `Backup/` for committing. |

All five scripts (`bootstrap`, `install`, `update`, `backup`, `check-links`) live in [`scripts/`](scripts) and share a small set of helpers (`set -euo pipefail`, colored output, per-tool guards).

### Stow packages

Each tool gets its own top-level package. All packages stow into `$HOME`; each one carries the right `.config/`, `.aria2/`, etc. structure inside it so stow puts files in the correct XDG location.

```
~/dotfiles/
  alacritty/.config/alacritty/...
  fish/.config/fish/...
  nvim/.config/nvim/...
  ...                              ← 13 XDG packages
  aria2/.aria2/aria2.conf
  claude/.claude/settings.json
  bash/.bashrc
  czrc/.czrc
  vim/.vimrc  vim/.ideavimrc
  zsh/.zshrc
```

The Makefile auto-discovers packages (every top-level dir except `scripts/`, `Backup/`, `.github/`, `.git/`) and runs a single `stow -v -t ~ <packages...>` call. Run `make print-packages` to see the current list.

Scripts under `scripts/` are written in zsh (`#!/usr/bin/env zsh`); the lint workflow runs `zsh -n` on each to catch syntax errors.

## Local Settings

### Shell

[Zsh](zsh/.zshrc) is the daily driver — kept lean, with eza/zoxide/fzf/bat/starship glue.

[Starship](https://starship.rs) handles the prompt — see [`config.toml`](starship/.config/starship/config.toml).

### Editors

|                         | Vim        | Neovim                    |
| ----------------------- | ---------- | ------------------------- |
| Main Configuration File | `~/.vimrc` | `~/.config/nvim/init.lua` |
| Configuration directory | `~/.vim`   | `~/.config/nvim`          |

[Helix](helix/.config/helix/config.toml) is also set up for quick edits.

### Multiplexer

Tmux config lives in [`tmux.conf`](tmux/.config/tmux/tmux.conf). Prefix is `C-Space`; `C-h/j/k/l` navigates panes (vim-aware), `M-h/j/k/l` resizes them. [Zellij](zellij/.config/zellij/config.kdl) is configured as an alternative.

### Terminals

Configs for [Ghostty](ghostty/.config/ghostty/config), [Kitty](kitty/.config/kitty/kitty.conf), and [Alacritty](alacritty/.config/alacritty/alacritty.toml) — Ghostty is the daily driver.

### Other tools

[lazygit](lazygit/.config/lazygit/config.yml), [tealdeer](tealdeer/.config/tealdeer/config.toml), [lf](lf/.config/lf/lfrc), [xplr](xplr/.config/xplr/init.lua), [helix](helix/.config/helix/config.toml).

### Color scheme

Everything is [Dracula](https://draculatheme.com)!

## Fonts

[JetBrains Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono) — installed via the `font-jetbrains-mono-nerd-font` cask in `Backup/Brewfile`.

## Author

👤 **Ivan** — [@IvanWng97](https://github.com/IvanWng97)

## Show your support

Give a ⭐️ if this project helped you!
