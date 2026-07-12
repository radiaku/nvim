# psmux root-table bindings shadow Neovim keys

`bind-key -n <key>` in psmux/tmux registers into the **root key table**: no prefix required, so the multiplexer intercepts that key on *every* keystroke in *every* pane — including while Neovim is the foreground process. Neovim never receives it.

Symptom: a key "stops working" inside nvim while its neighbour still works, with no matching mapping anywhere in the nvim config. E.g. `Ctrl+j` dead in Telescope / buffer nav while `Ctrl+k` is fine — because only `C-j` sat in the root table.

`~/.psmux.conf` shipped `bind-key -n C-j choose-session`, which ate `<C-j>` from Telescope (`move_selection_next`) and the cmdline wildmenu map. Fixed by moving it behind the prefix: `bind-key j choose-session`.

Diagnose:
```
psmux list-keys -T root     # everything the multiplexer steals before nvim sees it
psmux source-file ~/.psmux.conf
```
`source-file` adds bindings but does not unbind; restart the server if a stale root binding lingers.

Rule: never use `-n` for a key Neovim maps. Prefix-bind it, or gate it on `#{pane_current_command}` if a no-prefix key is really wanted.

Links: [[60-nupsmux]] · [[40-keymaps]] · [[index]]

Tags: [[tags#external|#external]] · [[tags#keymaps|#keymaps]] · [[tags#gotcha|#gotcha]]
