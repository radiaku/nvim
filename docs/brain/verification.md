# Verification (no test runner)

This repo has **no build, lint, or test pipeline**. "Running" the config is launching `nvim`; the verification surface is Neovim itself.

To validate a change:
1. Restart Neovim, watch for startup errors.
2. `:Msgs` — custom command that dumps `:messages` into a scratch buffer (defined in `core/init.lua`).
3. `:Lazy` — plugin state, load errors, profiling.
4. `:checkhealth` — provider/environment diagnostics.
5. `:Lazy sync` — reconcile installed plugins with the pinned commits. → [[pinned-commits]]

Caveat: a missing LSP binary does **not** error on desktop — the server is silently skipped. Absence of an error is not proof a server loaded. → [[lsp-direct-path]]

Links: [[index]] · [[load-order]] · [[pinned-commits]]

#workflow #core
