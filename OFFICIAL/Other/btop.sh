#!/usr/bin/env bash
pkgname=btop
pkgver=1.4.0
pkgrel=1
desc="Resource monitor"
url="https://github.com/aristocratos/btop"

sources=(
  "https://github.com/aristocratos/btop/archive/v${pkgver}.tar.gz|SKIP|btop-${pkgver}.tar.gz"
)

depends=()
makedepends=(base-devel)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/btop-${pkgver}.tar.gz"
  mv "btop-${pkgver}" src
}

build() {
  cd "${BUILD_DIR}/src"
  make -j"${ARTIX_MAKEFLAGS}"
}

package() {
  cd "${BUILD_DIR}/src"
  make DESTDIR="${PKG_DESTDIR}" install
}