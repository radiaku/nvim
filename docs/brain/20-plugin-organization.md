# Plugin organization

Plugin specs live under `lua/radia/plugins/<category>/*.lua`. Each `.lua` file **returns a lazy.nvim spec table** (or a list of them). Categories:

`ui` · `files` · `navigation` · `git` · `editing` · `diagnostics` · `language` · `terminal` · `session` · `tools` · `notes`

A category becomes active only when `core/init.lua` imports it via `{ import = "radia.plugins.<category>" }`. → [[11-lazy-bootstrap]]

Rules of the road:
- One plugin per file, named after the plugin.
- To add a plugin: drop a `return {...}` spec file into the right category folder. No registration needed if that category is already imported.
- To add a *new* category folder: also add the `{ import }` line in `core/init.lua`.
- Pin the commit. → [[22-pinned-commits]]
- To park a plugin without deleting it, move it to `disabled/`. → [[21-disabled-plugins]]

Some specs carry Windows build notes inline (e.g. `navigation/telescope.lua` has cmake fallbacks for `telescope-fzf-native`). → [[51-windows-pwsh]]

Links: [[index]] · [[21-disabled-plugins]] · [[22-pinned-commits]] · [[11-lazy-bootstrap]]

Tags: [[tags#plugins|#plugins]] · [[tags#core|#core]]
