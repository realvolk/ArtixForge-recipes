#!/usr/bin/env bash
pkgname=ripgrep
pkgver=14.1.0
pkgrel=1
desc="Line-oriented search tool"
url="https://github.com/BurntSushi/ripgrep"

sources=(
  "https://github.com/BurntSushi/ripgrep/archive/${pkgver}.tar.gz|SKIP|ripgrep-${pkgver}.tar.gz"
)

depends=()
makedepends=(base-devel rust cargo)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/ripgrep-${pkgver}.tar.gz"
  mv "ripgrep-${pkgver}" src
}

build() {
  cd "${BUILD_DIR}/src"
  cargo build --release
}

package() {
  cd "${BUILD_DIR}/src"
  mkdir -p "${PKG_DESTDIR}/usr/bin"
  cp target/release/rg "${PKG_DESTDIR}/usr/bin/"
}