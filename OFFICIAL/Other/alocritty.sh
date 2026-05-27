#!/usr/bin/env bash
pkgname=alacritty
pkgver=0.14.0
pkgrel=1
desc="GPU-accelerated terminal emulator"
url="https://alacritty.org"

sources=(
  "https://github.com/alacritty/alacritty/archive/v${pkgver}.tar.gz|SKIP|alacritty-${pkgver}.tar.gz"
)

depends=(fontconfig freetype)
makedepends=(base-devel rust cargo cmake)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/alacritty-${pkgver}.tar.gz"
  mv "alacritty-${pkgver}" src
}

build() {
  cd "${BUILD_DIR}/src"
  cargo build --release
}

package() {
  cd "${BUILD_DIR}/src"
  mkdir -p "${PKG_DESTDIR}/usr/bin"
  cp target/release/alacritty "${PKG_DESTDIR}/usr/bin/"
}