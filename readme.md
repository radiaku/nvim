Config for my neovim, you need atleast neovim 0.10.1+ until neovim 0.10.4 ( many breaking change )

# install neovim linux
```
curl -LO https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
```

# Install:
```
git clone https://github.com/radiaku/nvim ~/.config/nvim
```



# Tool
- Install fd-find https://github.com/sharkdp/fd
- Install ripgrep https://github.com/BurntSushi/ripgrep 
- Install fzf https://github.com/junegunn/fzf

# Linux
```
sudo apt install fzf
sudo apt install fd 
sudo apt install lua 
sudo apt install luarocks 
sudo apt install luajit 
sudo apt install python3-pip
sudo apt install python3-venv -y
apt install unzip 7z

```
- Install rust https://rustup.rs/

# Windows
- Install https://www.msys2.org/
    - Add it to path, usually: `C:\msys64\mingw64\bin`

- Install Scoop
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

```    
- or Advanced Scoop 
```
irm get.scoop.sh -outfile 'install.ps1'
then
.\install.ps1 -ScoopDir 'C:\Scoop' -ScoopGlobalDir 'C:\GlobalScoop' -NoProxy

```
- Run Scoop 
```
scoop bucket add extras
scoop bucket add nerd-fonts

scoop install 7zip cacert curl fzf fd gawk gzip innounp lazygit  lua-for-windows luarocks ripgrep sed sudo unzip vim wget 
```

- Install NODE js  https://nodejs.org/en
```
npm install -g neovim

    - if you dont install rust
    npm install -g tree-sitter-cli
```
- Install rust https://rustup.rs/
```
rustup toolchain install stable-x86_64-pc-windows-gnu
cargo install cargo-update
cargo install tree-sitter-cli
```



# Note
```
Dont forget checking for fzf searching on windows
check on keymaps.lua for all map keymap
telescope.lua
```

