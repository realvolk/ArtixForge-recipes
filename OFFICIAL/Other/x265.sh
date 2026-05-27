#!/usr/bin/env bash
pkgname=x265
pkgver=3.6
pkgrel=1
desc="H.265/HEVC video encoder"
url="https://www.videolan.org/developers/x265.html"

sources=(
  "https://bitbucket.org/multicoreware/x265_git/downloads/x265_${pkgver}.tar.gz|SKIP|x265-${pkgver}.tar.gz"
)

depends=()
makedepends=(base-devel cmake nasm)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/x265-${pkgver}.tar.gz"
  mv "x265_${pkgver}" src
}

configure() {
  mkdir -p "${BUILD_DIR}/src/build"
  cd "${BUILD_DIR}/src/build"
  cmake ../source -DCMAKE_INSTALL_PREFIX=/usr
}

build() {
  cd "${BUILD_DIR}/src/build"
  make -j"${ARTIX_MAKEFLAGS}"
}

package() {
  cd "${BUILD_DIR}/src/build"
  make DESTDIR="${PKG_DESTDIR}" install
}