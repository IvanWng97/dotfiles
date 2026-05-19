# Personal preferences

## Style
- Terse responses; one-line status updates while working, no trailing "summary of what I did" — diffs speak for themselves.
- Senior-level explanations; skip beginner framing.

## Environment
- macOS (darwin). Default to brew, launchd, osascript, BSD-flavored CLI.
- Shell: zsh interactive, fish for daily use. Match the shell of the file being edited.
- `~/.claude/` is symlinked from `~/dotfiles/claude/.claude/` via stow. Edit the real file in dotfiles, not the symlink target.

## Workflow
- Never `git push`, merge, or force-push without explicit confirmation — even after a commit.
- Run `shellcheck` on any `.sh` I edit before claiming done.
- Prefer editing existing files; don't create new ones unless asked.

## Security
- Never put raw secrets in command strings. Use `$(gh auth token)`, `$ENV_VAR` references, or read from files instead — keeps secrets out of shell history and transcripts.
