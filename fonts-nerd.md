# Nerd Font (Iosevka) — Quick Install Guide

Simple, copy‑pasteable commands to install Iosevka Nerd Font (IosevkaTerm) on Termux (Android), Linux, and Windows. JetBrainsMono instructions are included below as an alternative.

Related installers:
- Termux setup: [installertermux.md](installertermux.md)
- Full setup: [installer.md](installer.md)

## Termux (Android)

```bash
pkg install -y curl unzip
mkdir -p ~/.termux

# Download the Nerd Font zip (IosevkaTerm variant)
TMP="${TMPDIR:-$PREFIX/tmp}"; mkdir -p "$TMP"
curl -fLo "$TMP/IosevkaTerm.zip" \
  https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/IosevkaTerm.zip

# Install mono regular TTF as Termux font
unzip -oj "$TMP/IosevkaTerm.zip" '*Mono-Regular.ttf' -d ~/.termux/
mv ~/.termux/IosevkaTermNerdFontMono-Regular.ttf ~/.termux/font.ttf

# Apply
termux-reload-settings
```

Notes:
- Termux uses a single `~/.termux/font.ttf`. You can swap to other weights later.

## Linux (User-level)

```bash
# Debian/Ubuntu: ensure tools
sudo apt update && sudo apt install -y curl unzip fontconfig || true

# Download and install to user fonts
mkdir -p ~/.local/share/fonts/IosevkaTermNerdFont
curl -fLo /tmp/IosevkaTerm.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/IosevkaTerm.zip
unzip -o /tmp/IosevkaTerm.zip -d ~/.local/share/fonts/IosevkaTermNerdFont

# Refresh font cache
fc-cache -fv
```

Set the font in your terminal config (e.g., Alacritty, WezTerm, Kitty):
- Use family name `IosevkaTerm Nerd Font` or `IosevkaTerm Nerd Font Mono`.

## Windows

### Using Winget (recommended)
```powershell
winget install --id NerdFonts.Iosevka -e
# or Term variant
winget install --id NerdFonts.IosevkaTerm -e
```

### Using Chocolatey (alternative)
```powershell
choco install nerd-fonts-iosevka -y
```

If package managers aren’t available:
```powershell
# Manual install via download
$url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/IosevkaTerm.zip"
$zip = "$env:TEMP\IosevkaTerm.zip"
Invoke-WebRequest -Uri $url -OutFile $zip
Expand-Archive -Force -Path $zip -DestinationPath "$env:TEMP\IosevkaTermNF"

# Open the folder and install selected TTFs (Ctrl+A → right‑click → Install for all users)
ii "$env:TEMP\IosevkaTermNF"
```

Then select the font in your terminal settings (Windows Terminal/Alacritty/WezTerm):
- `IosevkaTerm Nerd Font` or `IosevkaTerm Nerd Font Mono`.

---

## JetBrainsMono Nerd Font — Alternative

### Termux (Android)
```bash
pkg install -y curl unzip
mkdir -p ~/.termux

TMP="${TMPDIR:-$PREFIX/tmp}"; mkdir -p "$TMP"
curl -fLo "$TMP/JetBrainsMono.zip" \
  https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip

unzip -oj "$TMP/JetBrainsMono.zip" '*Mono-Regular.ttf' -d ~/.termux/
mv ~/.termux/JetBrainsMonoNerdFontMono-Regular.ttf ~/.termux/font.ttf

termux-reload-settings
```

### Linux (User-level)
```bash
sudo apt update && sudo apt install -y curl unzip fontconfig || true

mkdir -p ~/.local/share/fonts/JetBrainsMonoNerdFont
curl -fLo /tmp/JetBrainsMono.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMonoNerdFont

fc-cache -fv
```

Set the font family to `JetBrainsMono Nerd Font` or `JetBrainsMono Nerd Font Mono` in your terminal.

### Windows
```powershell
# Winget (preferred)
winget install --id NerdFonts.JetBrainsMono -e

# Chocolatey (alternative)
choco install nerd-fonts-jetbrainsmono -y
```

Manual install:
```powershell
$url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip"
$zip = "$env:TEMP\JetBrainsMono.zip"
Invoke-WebRequest -Uri $url -OutFile $zip
Expand-Archive -Force -Path $zip -DestinationPath "$env:TEMP\JetBrainsMonoNF"
ii "$env:TEMP\JetBrainsMonoNF"  # Install selected TTFs (Install for all users)
```

Select the font as `JetBrainsMono Nerd Font` or `JetBrainsMono Nerd Font Mono` in Windows Terminal/Alacritty/WezTerm.