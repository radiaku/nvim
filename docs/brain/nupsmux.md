# nupsmux

**Not Neovim config.** `nupsmux/` is standalone documentation + a saved patch for a custom **psmux** (a tmux fork) build with **Nushell** project-session integration on Windows. It has zero effect on the nvim runtime.

Contents:
- `nupsmux/README.md` — build psmux from source with PR #393, Nushell `config.nu` functions (`psmux-session-name`, `psmux-here`, `psmux-project`), psmux.conf, troubleshooting, file locations.
- `nupsmux/pr-393.patch` — saved patch fixing `attach -t SESSION` attaching to the wrong session (in case the PR branch disappears).

Why it matters for orientation: recent git history ("fixing nu", "nupsmux", "adding patching") is about *this*, not the editor config — don't conflate the two when reading the log.

Session naming convention: first-letter abbreviation of all but the last 3 path components (e.g. `C:\Users\akura\Dev\Work\foo` → `c_u_a_Dev_Work_foo`).

Links: [[index]]

#external
