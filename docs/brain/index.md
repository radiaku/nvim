# 🧠 Brain — radia nvim config

Root of the knowledge graph. Each leaf is an **atomic note**: one concept, one file, linked by `[[wikilinks]]` and tagged into [[tags]].

> **Convention:** notes are atomic (a single idea), self-contained, and connected — not chaptered. To learn a topic, open its note and walk its links.

## How notes are numbered (flow)

The filename prefix encodes **where the concept sits in the flow** of this config, so an alphabetical file listing reads as the startup story:

| Prefix | Cluster | Meaning |
|--------|---------|---------|
| `1x` | Bootstrap & flow | how nvim comes up, in what order, how to verify |
| `2x` | Plugins | spec organization, pinning, plugin-level gotchas |
| `3x` | LSP | the two-path LSP architecture and its guards |
| `4x` | UI & input | keymaps and theming (load-order steps 2–3) |
| `5x` | Cross-platform | the Termux/Windows dimension that cuts across everything |
| `6x` | Outside the runtime | psmux/Nushell tooling that is *not* nvim config |

`index.md` (this file) and [[tags]] stay unnumbered — they are the maps, not the territory.

## Startup flow

What happens when `nvim` launches, and which note owns each step:

```mermaid
flowchart TD
    init["init.lua<br/>sets leader = space first"] --> core["step 1 · radia.core<br/>10-load-order"]
    core --> boot["bootstrap lazy.nvim<br/>11-lazy-bootstrap"]
    boot --> imports["lazy.setup: category imports<br/>20-plugin-organization"]
    imports --> lsp["explicit LSP requires<br/>30-lsp-architecture"]
    core --> keymaps["step 2 · radia.keymaps<br/>40-keymaps"]
    keymaps --> themes["step 3 · radia.themes<br/>41-theme-system"]
    themes --> neovide["step 4 · radia.neovide<br/>(GUI only)"]
    neovide --> last["step 5 · radia.last<br/>53-filetype-overrides"]

    style init fill:#2d333b,stroke:#768390,color:#adbac7
    style core fill:#1c3d5c,stroke:#539bf5,color:#adbac7
    style last fill:#3d2d1c,stroke:#daaa3f,color:#adbac7
```

## LSP attach decision

How a buffer ends up with (or without) a language server:

```mermaid
flowchart TD
    open["buffer opened"] --> guard{"file exists on disk?<br/>34-lsp-deleted-file-guard"}
    guard -- "no (deleted / unsaved)" --> skip["no LSP attach<br/>retries after first :w"]
    guard -- yes --> platform{"is_termux()?<br/>50-termux-detection"}
    platform -- yes --> direct["direct path: system binaries<br/>32-lsp-direct-path"]
    platform -- no --> mason["Mason path: managed servers<br/>31-lsp-mason-path"]
    direct --> shared["shared helpers<br/>33-lsp-shared-libs"]
    mason --> shared

    style guard fill:#3d1c1c,stroke:#e5534b,color:#adbac7
    style platform fill:#1c3d5c,stroke:#539bf5,color:#adbac7
```

## Tree

- **1x · Bootstrap & flow** — how nvim comes up
  - [[10-load-order]] — strict five-step require sequence in `init.lua`
  - [[11-lazy-bootstrap]] — how lazy.nvim installs itself and loads specs
  - [[12-verification]] — no test runner; how to validate a change
- **2x · Plugins** — specs and their lifecycle
  - [[20-plugin-organization]] — category folders → `{ import }`
  - [[21-disabled-plugins]] — the dormant `disabled/` directory
  - [[22-pinned-commits]] — inline `commit =` is the real lockfile
  - [[23-formatting-on-save]] — conform.nvim; black timeout → libuv race
  - [[24-telescope-previewer-no-shell]] — don't spawn `head`/`echo` (Windows trap)
- **3x · LSP** — two parallel setup paths
  - [[30-lsp-architecture]] — the hub: one config, two paths
  - [[31-lsp-mason-path]] — desktop, Mason-managed
  - [[32-lsp-direct-path]] — Termux, system binaries
  - [[33-lsp-shared-libs]] — `lib/` helpers both paths share
  - [[34-lsp-deleted-file-guard]] — no attach when the file is gone from disk
- **4x · UI & input** — steps 2–3 of the load order
  - [[40-keymaps]] — keymap load chain
  - [[41-theme-system]] — `_G.themesname` set in core, applied in themes
- **5x · Cross-platform** — the dimension that cuts across everything
  - [[50-termux-detection]] — the `com.termux` switch
  - [[51-windows-pwsh]] — pwsh shell wiring
  - [[52-clipboard]] — deferred enable + Termux provider
  - [[53-filetype-overrides]] — extension → filetype remaps
- **6x · Outside the runtime** — adjacent tooling, not nvim config
  - [[60-nupsmux]] — psmux/Nushell session tooling
  - [[61-psmux-key-shadowing]] — `bind-key -n` steals keys from nvim

## Indexes

- [[tags]] — every tag and the notes under it

Tags: [[tags#moc|#moc]] · [[tags#core|#core]]
