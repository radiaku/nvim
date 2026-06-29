# docs/

Documentation for this Neovim config.

## 🧠 Brain — atomic knowledge graph

The architecture is documented as an Obsidian-style vault of **atomic notes** (one concept per file) connected by `[[wikilinks]]` and `#tags`. Start at the root and follow the branches:

→ **[brain/index.md](brain/index.md)**

- Each note is self-contained and links to its neighbors.
- `brain/tags.md` is the tag index; `brain/index.md` is the tree / map-of-content.
- Best read in Obsidian or with `obsidian.nvim` — `docs/brain` is registered as the **`brain`** workspace, so wikilinks and backlinks resolve. See `lua/radia/plugins/notes/obsidian.lua`.

## Other docs

- `../CLAUDE.md` — condensed architecture guide for AI assistants
- `../readme.md` — user-facing quick start
- `../installer/` — per-platform setup guides
- `../lua/radia/lsp/README.md` — LSP module breakdown
