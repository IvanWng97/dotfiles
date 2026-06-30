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
- When another Claude Code session may run in the same repo concurrently, work in a `git worktree` (or the native worktree tool), never the shared checkout — two sessions on one working tree race on HEAD and uncommitted changes.

## Security
- Never put raw secrets in command strings. Use `$(gh auth token)`, `$ENV_VAR` references, or read from files instead — keeps secrets out of shell history and transcripts.

## Memory (mem0)
- Shared cross-tool memory lives in the mem0 MCP server `mem0-mcp` (hosted, `https://mcp.mem0.ai/mcp`), shared by Claude, Codex, and openclaw. Free tier = **1 project**, so partition logically with metadata — never by separate projects.
- **Identity:** always pass `user_id: "ivanwng97"` on every call (`add_memory`/`search_memories`/`get_memories`); the hosted endpoint has no pinned default. **Never set `agent_id`** (fragments scope, breaks reads) and **never AND two entity IDs** — e.g. `AND(user_id, app_id)` returns empty due to null-default mismatch.
- **Repo scoping lives in `metadata`, not entity IDs.** Every write carries `metadata.scope`:
  - cross-repo profile fact → `metadata={"scope":"global"}`
  - repo-specific fact (architecture, bug root-cause, runbook, local convention) → `metadata={"scope":"repo","repo":"<repo-name>"}`
- **Reads must AND the metadata** — a bare `user_id` filter mixes global + every repo together. Metadata keys MUST be nested under a `metadata` clause; a bare top-level `{"repo":…}`/`{"scope":…}` ERRORS (only `user_id`/`agent_id`/`app_id`/`run_id`/`metadata`/`categories`/timestamps are valid top-level filter keys — verified vs the live hosted API 2026-06-30):
  - repo: `filters={"AND":[{"user_id":"ivanwng97"},{"metadata":{"repo":"<repo-name>"}}]}`
  - profile: `filters={"AND":[{"user_id":"ivanwng97"},{"metadata":{"scope":"global"}}]}`
- Free-tier budget: **~1,000 searches/mo (~33/day)** is the binding limit; 10,000 writes/mo. Guard searches, not writes. ≤1 `search_memories` per session (`top_k=3`, default threshold, no rerank); reuse it. Use `get_memories(filters=...)` (list op) for "everything in scope".
- Write: batch durable facts into **one `add_memory`** with `infer=true` (extracts atomic memories + MD5-dedups). Store only durable signal — preferences, decisions, env, corrections — **never** secrets, scratch output, or speculation. No per-turn chatter; writes are model-judged (no auto Stop-hook). Don't mix `infer=true`/`false` for the same fact (double-stores).
- Verify a write **for free** via `get_event_status(event_id)`; never re-`search` to confirm.
- A repo's own `metadata.repo` tag is declared in that repo's `CLAUDE.md` (one line); everything else here is global.

@RTK.md
