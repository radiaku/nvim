1) Prep & deps
```
pkg update && pkg upgrade -y
pkg install -y git cmake ninja build-essential gettext curl unzip
# Optional (for :checkhealth)
pkg install -y python-pip tree-sitter ripgrep fd clang
pip install --user --upgrade pynvim

```

2) Get the 0.10.4 source

```
cd ~
git clone --branch v0.10.4 --depth=1 https://github.com/neovim/neovim.git
cd neovim
```
3) Build for Termux prefix
```
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$PREFIX" \
     -j"$(nproc)"
```
4) Install
```
make install
hash -r     # refresh shell command cache
nvim --version | head -n 3
```
