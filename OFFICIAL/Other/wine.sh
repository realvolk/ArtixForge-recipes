#!/usr/bin/env bash
pkgname=wine
pkgver=9.0
pkgrel=1
desc="Windows compatibility layer"
url="https://www.winehq.org"

sources=(
  "https://dl.winehq.org/wine/source/9.0/wine-${pkgver}.tar.xz|SKIP|wine-${pkgver}.tar.xz"
)

depends=()
makedepends=(base-devel flex bison)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/wine-${pkgver}.tar.xz"
  mv "wine-${pkgver}" src
}

configure() {
  cd "${BUILD_DIR}/src"
  ./configure --prefix=/usr --enable-win64
}

build() {
  cd "${BUILD_DIR}/src"
  make -j"${ARTIX_MAKEFLAGS}"
}

package() {
  cd "${BUILD_DIR}/src"
  make DESTDIR="${PKG_DESTDIR}" install
}