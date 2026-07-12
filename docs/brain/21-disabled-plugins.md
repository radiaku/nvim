# Disabled plugins

`lua/radia/plugins/disabled/` holds **parked specs**. This folder is *not* listed in any `{ import }` call in `core/init.lua`, so lazy.nvim never sees it — every file inside is dormant.

- **Disable** a plugin → move its file into `disabled/`.
- **Re-enable** → move it back into a real category folder that is imported. → [[20-plugin-organization]]

This is preferred over deleting: the spec (and its pinned commit, settings, inline notes) survives for later. Examples currently parked: `copilot`, `dap`, `roslyn`, `nvim-tree`, `refactoring`, `yazi`, and many more.

Contrast with [[33-lsp-shared-libs]], which live outside `plugins/` for the *opposite* reason — to be loaded explicitly rather than auto-imported.

Links: [[20-plugin-organization]] · [[index]]

Tags: [[tags#plugins|#plugins]]
