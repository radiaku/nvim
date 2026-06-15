# Git Profile Setup

> **Step 3** · Tags: #all #optional | [Index](README.md)

Use separate Git identities and SSH keys for personal, work, and tutorial repositories.

## 1. Create SSH keys

Replace the example emails with your own Git hosting emails.

```bash
ssh-keygen -t ed25519 -C "you@example.com" -f ~/.ssh/id_ed25519_global
ssh-keygen -t ed25519 -C "you@work.example.com" -f ~/.ssh/id_ed25519_work
ssh-keygen -t ed25519 -C "you+personal@example.com" -f ~/.ssh/id_ed25519_personal
chmod 600 ~/.ssh/id_ed25519_global ~/.ssh/id_ed25519_work ~/.ssh/id_ed25519_personal
```

If you want the global key to be your default SSH key, back up any existing default key first:

```bash
if [ -e ~/.ssh/id_ed25519 ]; then
  cp ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.backup.$(date +%Y%m%d-%H%M%S)
fi
if [ -e ~/.ssh/id_ed25519.pub ]; then
  cp ~/.ssh/id_ed25519.pub ~/.ssh/id_ed25519.pub.backup.$(date +%Y%m%d-%H%M%S)
fi
cp ~/.ssh/id_ed25519_global ~/.ssh/id_ed25519
cp ~/.ssh/id_ed25519_global.pub ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/id_ed25519
```

## 2. Add keys to the SSH agent

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_global
ssh-add ~/.ssh/id_ed25519_work
ssh-add ~/.ssh/id_ed25519_personal
```

## 3. Set a global Git identity

```bash
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

## 4. Configure per-folder identities

Edit `~/.gitconfig`:

```gitconfig
[user]
    name = Your Name
    email = you@example.com

[includeIf "gitdir:~/Dev/personal/**"]
    path = ~/Dev/personal/.gitconfig

[includeIf "gitdir:~/Dev/work/**"]
    path = ~/Dev/work/.gitconfig

[includeIf "gitdir:~/Dev/tutorial/**"]
    path = ~/Dev/tutorial/.gitconfig
```

Example `~/Dev/work/.gitconfig`:

```gitconfig
[user]
    name = Work Name
    email = you@work.example.com

[core]
    sshCommand = "ssh -i ~/.ssh/id_ed25519_work -o IdentitiesOnly=yes"
```

Example `~/Dev/personal/.gitconfig`:

```gitconfig
[user]
    name = Personal Name
    email = you+personal@example.com

[core]
    sshCommand = "ssh -i ~/.ssh/id_ed25519_personal -o IdentitiesOnly=yes"
```

## 5. Verify inside a repository

Run these commands from a cloned repository under one of the configured folders:

```bash
git config --get user.email
git config --get core.sshCommand
git config --get --show-origin core.sshCommand
```

If the output shows the expected email and SSH key, the profile is active.
