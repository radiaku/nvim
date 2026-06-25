# nupsmux — Nushell + psmux (tmux fork) Setup Guide

## Overview

Custom psmux build with PR #393 patch to fix `attach -t SESSION` attaching to wrong session.
Nushell integration for project-based session management.

---

## Build psmux from Source (with PR #393)

### 1. Clone & fetch PR

```bash
git clone https://github.com/psmux/psmux.git ~/psmux-build
cd ~/psmux-build
git fetch origin pull/393/head:pr-393
git checkout pr-393
```

### Alternative: Apply saved local patch

If PR #393 disappears or GitHub changes the branch, use the saved patch:

```bash
git clone https://github.com/psmux/psmux.git ~/psmux-build
cd ~/psmux-build
git apply ~/AppData/Local/nvim/nupsmux/pr-393.patch
```

Saved patch:

```
~\AppData\Local\nvim\nupsmux\pr-393.patch
```

### 2. Build (requires Rust/Cargo)

```bash
cargo build --release
```

Binary: `target/release/psmux.exe`

### 3. Install

```bash
# Create local bin
mkdir -p ~/.local/bin

# Copy binary
cp target/release/psmux.exe ~/.local/bin/

# Create tmux alias (psmux uses argv[0] for socket naming)
cp target/release/psmux.exe ~/.local/bin/tmux.exe

# Uninstall winget version to avoid conflicts
winget uninstall psmux --source winget
```

### 4. Add to PATH

Ensure `~/.local/bin` is in your PATH before any system directories.

---

## Session Naming Convention

Sessions are named after their project directory path:

```
C:\Users\akura\Dev\Work\fosilwithbrain
  → C_Users_akura_Dev_Work_fosilwithbrain
```

Rules:
- `\` → `_`
- `:` → `_` (Windows drive letter)

---

## Nushell Config (`config.nu`)

Add to `$nu.config-path`:

```nushell
# Generate alphanumeric session name from path (no slashes, colons, spaces)
def psmux-session-name [dir: string] {
    $dir
    | str replace -a "\\" "_"
    | str replace -a ":" ""
    | str replace -a " " "_"
    | str replace -a "-" "_"
    | str replace -a "." "_"
    | str replace -r '[^a-zA-Z0-9_]' "_"
}

# Ensure psmux server is running (called before any psmux command)
def psmux-ensure-server [] {
    let info = (^psmux server-info | complete)
    if ($info.exit_code != 0) {
        ^psmux new-session -ds default
    }
}

# psmux: create/attach session for current directory
def psmux-here [] {
    psmux-ensure-server
    let session = (psmux-session-name $env.PWD)
    do -i { ^psmux new-session -ds $session -c $env.PWD }
    if ($env.TMUX? | is-not-empty) {
        ^psmux switch-client -t $session
    } else {
        ^psmux attach -t $session
    }
}

# psmux project picker: choose folder from ~/Dev/, create (or attach if exists)
def psmux-project [] {
    psmux-ensure-server
    let roots = [
        ($env.USERPROFILE | path join "Dev" "Work")
        ($env.USERPROFILE | path join "Dev" "Personal")
    ]

    let dirs = ($roots | each {|r|
        if ($r | path exists) {
            ls $r | where type == dir | get name
        }
    } | flatten)

    if ($dirs | is-empty) {
        print "No project directories found."
        return
    }

    let pick = ($dirs | path basename | to text | ^fzf --prompt="project> " --height=40% | str trim)
    if ($pick | is-empty) { return }

    let parent = ($roots | where {|r| ($r | path join $pick) in $dirs } | first)
    let dir = ($parent | path join $pick)
    let session = (psmux-session-name $dir)

    do -i { ^psmux new-session -ds $session -c $dir }

    if ($env.TMUX? | is-not-empty) {
        ^psmux switch-client -t $session
    } else {
        ^psmux attach -t $session
    }
}

$env.config.keybindings = ($env.config.keybindings | append {
    name: "psmux_project"
    modifier: "control"
    keycode: "char_f"
    mode: [emacs, vi_normal, vi_insert]
    event: {
        send: executehostcommand
        cmd: "psmux-project"
    }
})

# Auto-start psmux server on startup
let _psmux_check = (^psmux server-info | complete)
if ($_psmux_check.exit_code != 0) {
    ^psmux new-session -ds default
}
```

Dependencies:
- `fzf`: `winget install fzf`

---

## psmux Config (`psmux.conf`)

Path: `~/.config/psmux/psmux.conf`

```
# Fix: C-b d should detach, not kill session
bind d detach-client

# Native session chooser (reliable on Windows)
bind-key -n C-j choose-session
```

Load manually if needed:
```bash
psmux source-file ~/.config/psmux/psmux.conf
```

---

## Troubleshooting

### `list-sessions` empty but `choose-session` shows sessions

Windows IPC issue — `psmux` CLI can't see the server from a new terminal context.
**Fix:** Use native keybindings (`choose-session`) instead of Nu scripts for listing.

### `attach -t` goes to wrong session (before patch)

PR #393 fixes this. The `-t` flag was stripped by argv pre-filter.
Workaround: use positional form `psmux attach SESSIONNAME`.

### Duplicate sessions with colons (e.g., `C:_Users_...`)

Session name didn't replace `:` in drive letter. Fixed in naming function.
Kill broken sessions:
```bash
psmux kill-session -t C:_Users_akura_Dev_Work_sessionname
```

### Two psmux servers running

Can happen if winget version wasn't fully uninstalled.
```bash
taskkill /f /im psmux.exe
# or
taskkill /f /im tmux.exe
```

---

## File Locations

| File | Path |
|---|---|
| Built binary | `~/.local/bin/psmux.exe` |
| tmux alias | `~/.local/bin/tmux.exe` |
| Nushell config | `~\AppData\Roaming\nushell\config.nu` |
| psmux config | `~/.config/psmux/psmux.conf` |
| Rebuild script | `~/.local/bin/psmux-rebuild.nu` |
| Saved PR #393 patch | `~\AppData\Local\nvim\nupsmux\pr-393.patch` |
| This doc | `~\AppData\Local\nvim\nupsmux\README.md` |

---

## Rebuild Script

`~/.local/bin/psmux-rebuild.nu`:

```nushell
# Rebuild psmux from source after PR merge
let tmp = ($env.TEMP | path join "psmux-build")

if ($tmp | path exists) {
    cd $tmp; git pull origin master
} else {
    git clone https://github.com/psmux/psmux.git $tmp
    cd $tmp
}

cargo build --release
psmux kill-server

let dest = ($env.USERPROFILE | path join ".local" "bin" "psmux.exe")
cp ($tmp | path join "target" "release" "psmux.exe") $dest
cp ($tmp | path join "target" "release" "psmux.exe") ($env.USERPROFILE | path join ".local" "bin" "tmux.exe")

print "Done. New psmux at:" $dest
```

---

## Keybindings Summary

| Key | Action |
|---|---|
| `Ctrl+F` | Project picker (fzf → create/attach session) |
| `Ctrl+B S` | Native session chooser (inside psmux) |
| `Ctrl+B D` | Detach client |
| `Ctrl+J` | Native session chooser (if configured in psmux.conf) |

---

## References

- PR #393: https://github.com/psmux/psmux/pull/393
- psmux repo: https://github.com/psmux/psmux
- Nushell docs: https://nushell.sh/book/
