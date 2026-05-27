#!/usr/bin/env bash
pkgname=neovim
pkgver=0.10.0
pkgrel=1
desc="Hyperextensible Vim-based text editor"
url="https://neovim.io"

sources=(
  "https://github.com/neovim/neovim/archive/v${pkgver}.tar.gz|SKIP|neovim-${pkgver}.tar.gz"
)

depends=()
makedepends=(base-devel cmake ninja gettext)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/neovim-${pkgver}.tar.gz"
  mv "neovim-${pkgver}" src
}

configure() {
  cd "${BUILD_DIR}/src"
  make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr
}

build() {
  cd "${BUILD_DIR}/src"
  make -j"${ARTIX_MAKEFLAGS}"
}

package() {
  cd "${BUILD_DIR}/src"
  make DESTDIR="${PKG_DESTDIR}" install
}