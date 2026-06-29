# 🧠 Brain — radia nvim config

Root of the knowledge graph. Each leaf is an **atomic note**: one concept, one file, linked by `[[wikilinks]]` and `#tags`. Start here and follow the branches.

> Convention: notes are atomic (a single idea), self-contained, and connected — not chaptered. To learn a topic, open its note and walk its links.

## Tree

- **Bootstrap & flow**
  - [[load-order]] — strict require sequence in `init.lua`
  - [[lazy-bootstrap]] — how lazy.nvim installs itself and loads specs
  - [[verification]] — there is no test runner; how to validate a change
- **Plugins**
  - [[plugin-organization]] — category folders → `{ import }`
  - [[disabled-plugins]] — the dormant `disabled/` directory
  - [[pinned-commits]] — inline `commit =` is the real lockfile
- **LSP**
  - [[lsp-architecture]] — two parallel setup paths (the hub)
  - [[lsp-mason-path]] — desktop, Mason-managed
  - [[lsp-direct-path]] — Termux, system binaries
  - [[lsp-shared-libs]] — `lib/` helpers both paths share
- **Cross-platform**
  - [[termux-detection]] — the `com.termux` switch
  - [[windows-pwsh]] — pwsh shell wiring
  - [[clipboard]] — deferred + Termux provider
  - [[filetype-overrides]] — extension → filetype remaps
- **UI & input**
  - [[theme-system]] — `_G.themesname` set in core, applied in themes
  - [[keymaps]] — keymap load chain
- **Outside the runtime**
  - [[nupsmux]] — psmux/Nushell session tooling (not nvim config)

## Indexes

- [[tags]] — every tag and the notes under it

#moc #core
