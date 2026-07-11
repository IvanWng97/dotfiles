<h1 align="center">Welcome to Ivan's dotfiles 👋</h1>

<p align="center">
  <a href="https://github.com/IvanWng97/dotfiles/actions/workflows/lint.yml"><img src="https://github.com/IvanWng97/dotfiles/actions/workflows/lint.yml/badge.svg" alt="lint"></a>
  <a href="https://github.com/IvanWng97/dotfiles/actions/workflows/bootstrap.yml"><img src="https://github.com/IvanWng97/dotfiles/actions/workflows/bootstrap.yml/badge.svg" alt="bootstrap"></a>
  <a href="https://github.com/IvanWng97/dotfiles/actions/workflows/brewfile.yml"><img src="https://github.com/IvanWng97/dotfiles/actions/workflows/brewfile.yml/badge.svg" alt="brewfile"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
</p>

💻 ghostty, zsh, fish, tmux, starship, helix, lazygit, homebrew — my whole world
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
| `make install` | Installs everything from `Backup/Brewfile` (brew bundle natively covers taps, formulas, casks, mas, vscode, cargo and npm) plus `requirements.txt`, fisher plugins from the stowed `fish_plugins`, tpm + plugins, and seeds `~/.claude/settings.json` if absent. |
| `make install-links` | Re-run `stow` to (re)create symlinks under `$HOME`. |
| `make uninstall-links` | Remove the symlinks (configs stay safe in `~/dotfiles/`). |
| `make relink` | `uninstall-links` then `install-links` — useful after adding a new file to a package. |
| `make symlinks-check` | Verify every package file has a matching, correctly-resolved symlink in `$HOME`; reports orphans too. Exits non-zero on issues. |
| `make doctor` | Run every health check at once: zsh syntax on each script, symlinks-check, Brewfile parses, git working tree clean. |
| `make update` | Upgrades brew/npm/pipx/cargo/mas/tmux packages and re-dumps `Backup/Brewfile` so it matches reality. |
| `make backup` | Re-dumps `Backup/Brewfile` + `requirements.txt` and snapshots `~/.claude/settings.json` into `Backup/` for committing. |

All six scripts (`bootstrap`, `install`, `update`, `backup`, `check-links`, `doctor`) live in [`scripts/`](scripts) and share a small set of helpers (strict mode, colored output, per-tool guards) — `update.sh` deliberately skips `-e` so one failing updater doesn't abort the rest.

### Stow packages

Each tool gets its own top-level package. All packages stow into `$HOME`; each one carries the right `.config/`, `.aria2/`, etc. structure inside it so stow puts files in the correct XDG location.

```
~/dotfiles/
  alacritty/.config/alacritty/...
  fish/.config/fish/...
  helix/.config/helix/...
  ...                              ← 13 XDG packages
  aria2/.aria2/aria2.conf
  claude/.claude/CLAUDE.md  claude/.claude/RTK.md
  bash/.bashrc
  czrc/.czrc
  vim/.vimrc  vim/.ideavimrc
  zsh/.zshrc
```

`~/.claude/settings.json` is the one config that is **not** stowed: Claude Code rewrites it in place, which would silently replace the symlink with a real file. Instead `make backup` snapshots it to `Backup/claude-settings.json` and `make install` seeds it on a fresh machine.

The Makefile auto-discovers packages (every top-level dir except `scripts/`, `Backup/`, `.github/`, `.git/`) and runs a single `stow -v -t ~ <packages...>` call. Run `make print-packages` to see the current list.

Scripts under `scripts/` are written in zsh (`#!/usr/bin/env zsh`); the lint workflow runs `zsh -n` on each to catch syntax errors.

### Pre-commit hooks (optional)

The same checks the CI runs (`gitleaks`, `actionlint`, `zsh -n`, plus trailing-whitespace / EOF / YAML / merge-conflict) are available as pre-commit hooks. Opt-in per clone:

```sh
brew install pre-commit
pre-commit install
```

## Local Settings

### Shell

[Zsh](zsh/.zshrc) is the daily driver — kept lean, with eza/zoxide/fzf/bat/starship glue.

[Starship](https://starship.rs) handles the prompt — see [`config.toml`](starship/.config/starship/config.toml).

### Editors

[Helix](helix/.config/helix/config.toml) for quick edits; classic [Vim](vim/.vimrc) config plus [`.ideavimrc`](vim/.ideavimrc) for JetBrains IDEs.

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

## License

[MIT](LICENSE) — feel free to fork, copy, and rip out whatever's useful.

## Show your support

Give a ⭐️ if this project helped you!
