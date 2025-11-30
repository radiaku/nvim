Copy this to a file like build-neovim-0.10.4.sh, make it executable, and run it.
```
#!/usr/bin/env bash
# Build & install Neovim v0.10.4 on Linux
# Usage:
#   ./build-neovim-0.10.4.sh [--prefix /usr/local] [--jobs 8] [--type Release] [--without-deps] [--without-bundled]
#   ./build-neovim-0.10.4.sh --help

set -euo pipefail

VERSION="v0.10.4"
PREFIX_DEFAULT="/usr/local"
JOBS="$(nproc || echo 4)"
BUILD_TYPE="Release"
INSTALL_DEPS=1
USE_BUNDLED=1
SRC_DIR="$HOME/src/neovim-$VERSION"
BUILD_DIR="$SRC_DIR/build"

log() { printf "\033[1;32m==>\033[0m %s\n" "$*"; }
err() { printf "\033[1;31mERR:\033[0m %s\n" "$*" >&2; }
die() { err "$*"; exit 1; }

usage() {
  cat <<EOF
Build Neovim $VERSION from source.

Options:
  --prefix <path>     Install prefix (default: $PREFIX_DEFAULT)
  --jobs <N>          Parallel jobs for build (default: $JOBS)
  --type <BuildType>  CMAKE_BUILD_TYPE (Release/RelWithDebInfo/Debug) default: $BUILD_TYPE
  --without-deps      Skip dependency installation
  --without-bundled   Do not use bundled third-party deps (requires system libluv >= 1.43)
  --src <dir>         Source checkout directory (default: $SRC_DIR)
  --help              Show this help

Examples:
  sudo ./build-neovim-0.10.4.sh
  ./build-neovim-0.10.4.sh --prefix "\$HOME/.local" --jobs 4   # user-local install
EOF
}

PREFIX="$PREFIX_DEFAULT"

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --prefix) PREFIX="${2:?}"; shift 2 ;;
    --jobs) JOBS="${2:?}"; shift 2 ;;
    --type) BUILD_TYPE="${2:?}"; shift 2 ;;
    --without-deps) INSTALL_DEPS=0; shift ;;
    --without-bundled) USE_BUNDLED=0; shift ;;
    --src) SRC_DIR="${2:?}"; BUILD_DIR="$SRC_DIR/build"; shift 2 ;;
    --help) usage; exit 0 ;;
    *) die "Unknown option: $1 (use --help)";;
  esac
done

need_cmd() { command -v "$1" &>/dev/null; }

detect_distro() {
  . /etc/os-release 2>/dev/null || true
  case "${ID:-}" in
    ubuntu|debian) echo "debian" ;;
    arch|manjaro|endeavouros|cachyos) echo "arch" ;;
    fedora) echo "fedora" ;;
    rhel|rocky|almalinux|centos) echo "rhel" ;;
    *) echo "unknown" ;;
  esac
}

install_deps_debian() {
  log "Installing deps via apt..."
  sudo apt-get update
  sudo apt install build-essential cmake git
  sudo apt-get install -y \
    git cmake ninja-build gettext libtool libtool-bin autoconf automake \
    g++ pkg-config unzip curl doxygen \
    libluv-dev libluv1
}
install_deps_fedora() {
  log "Installing deps via dnf..."
  sudo dnf install -y \
    git cmake ninja-build gettext libtool autoconf automake gcc-c++ \
    pkgconfig unzip curl doxygen \
    luv-devel
}
install_deps_rhel() {
  log "Installing deps via dnf/yum..."
  if need_cmd dnf; then
    sudo dnf groupinstall -y "Development Tools"
    sudo dnf install -y \
      git cmake ninja-build gettext libtool autoconf automake gcc-c++ \
      pkgconfig unzip curl doxygen
  else
    sudo yum groupinstall -y "Development Tools"
    sudo yum install -y \
      git cmake ninja-build gettext libtool autoconf automake gcc-c++ \
      pkgconfig unzip curl doxygen
  fi
}
install_deps_arch() {
  log "Installing deps via pacman..."
  sudo pacman -Syu --noconfirm
  sudo pacman -S --noconfirm \
    git cmake ninja gettext libtool autoconf automake base-devel \
    pkgconf unzip curl doxygen \
    luv
}

install_build_deps() {
  [[ "$INSTALL_DEPS" -eq 1 ]] || { log "Skipping dependency installation (--without-deps)"; return; }
  need_cmd sudo || die "sudo is required for dependency installation (or use --without-deps)."
  case "$(detect_distro)" in
    debian) install_deps_debian ;;
    fedora) install_deps_fedora ;;
    rhel)   install_deps_rhel ;;
    arch)   install_deps_arch ;;
    *)
      err "Unknown distro. Please install build deps manually:"
      echo "  git cmake ninja gettext libtool autoconf automake gcc/g++ pkg-config unzip curl doxygen"
      ;;
  esac
}

clone_source() {
  if [[ -d "$SRC_DIR/.git" ]]; then
    log "Source exists at $SRC_DIR; fetching & checking out $VERSION"
    git -C "$SRC_DIR" fetch --depth=1 origin "refs/tags/$VERSION:refs/tags/$VERSION" || true
    git -C "$SRC_DIR" checkout -f "$VERSION"
  else
    log "Cloning Neovim $VERSION to $SRC_DIR"
    mkdir -p "$(dirname "$SRC_DIR")"
    git clone --branch "$VERSION" --depth=1 https://github.com/neovim/neovim.git "$SRC_DIR"
  fi
}

build_neovim() {
  log "Configuring build: type=$BUILD_TYPE, prefix=$PREFIX"
  mkdir -p "$BUILD_DIR"
  local use_bundled_flag="ON"
  [[ "$USE_BUNDLED" -eq 1 ]] || use_bundled_flag="OFF"
  cmake -S "$SRC_DIR" -B "$BUILD_DIR" \
    -G Ninja \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DUSE_BUNDLED="$use_bundled_flag"
  log "Building with $JOBS job(s)…"
  cmake --build "$BUILD_DIR" -- -j"$JOBS"
}

install_neovim() {
  log "Installing to $PREFIX (may require sudo if prefix is system-wide)…"
  if [[ "$PREFIX" == "/usr" || "$PREFIX" == "/usr/local" ]]; then
    need_cmd sudo || die "sudo required for system prefix install; use --prefix \$HOME/.local to install without sudo."
    sudo cmake --install "$BUILD_DIR"
  else
    cmake --install "$BUILD_DIR"
  fi
}

post_checks() {
  log "Verifying installation…"
  if ! need_cmd nvim; then
    err "nvim not found in PATH. Add $PREFIX/bin to PATH."
    echo "  export PATH=\"$PREFIX/bin:\$PATH\""
    echo "If you saw an error about missing Luv, either re-run with bundled deps (default) or install system packages:"
    echo "  Debian/Ubuntu: sudo apt-get install libluv-dev libluv1"
    echo "  Fedora: sudo dnf install luv-devel"
    echo "  Arch: sudo pacman -S luv"
  else
    nvim --version | head -n 5
  fi
}

main() {
  install_build_deps
  clone_source
  build_neovim
  install_neovim
  post_checks
  log "Done. Enjoy Neovim $VERSION!"
}

main "$@"


```

2) QuickStart
 aj
```
chmod +x build-neovim-0.10.4.sh
# System-wide (needs sudo):
sudo ./build-neovim-0.10.4.sh
# User-local (no sudo):
./build-neovim-0.10.4.sh --prefix "$HOME/.local"

```
3) export path
```
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

4) Troubleshooting: Luv packages not found on Debian/Ubuntu

- If `apt` can’t find `libluv-dev`/`libluv1`:
  - Enable Universe (Ubuntu):
    - `sudo add-apt-repository universe`
    - `sudo apt-get update`
    - `sudo apt-get install libluv-dev libluv1`
  - On Debian or minimal environments, `libluv` may be unavailable; prefer bundled deps or build from source.

5) Quick path: build with bundled deps

- Bundled deps avoid system `luv` entirely and are enabled in the script.
- Manual CMake:
  - `cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DUSE_BUNDLED=ON`
  - `cmake --build build -j$(nproc)`
  - `sudo cmake --install build`
- or using Make helpers:
  - `make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr/local deps`
  - `make CMAKE_BUILD_TYPE=Release`
  - `sudo make install`

Notes
- The error “Could NOT find Luv (Required >= 1.43.0)” means system `luv` is missing or too old.
- Using bundled deps is the simplest way to satisfy Neovim’s dependency versions across distros.
