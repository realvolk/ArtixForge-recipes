#!/usr/bin/env bash
pkgname=x264
pkgver=0.164
pkgrel=1
desc="H.264/AVC video encoder"
url="https://www.videolan.org/developers/x264.html"

sources=(
  "https://code.videolan.org/videolan/x264/-/archive/master/x264-master.tar.bz2|SKIP|x264-${pkgver}.tar.bz2"
)

depends=()
makedepends=(base-devel nasm)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/x264-${pkgver}.tar.bz2"
  mv x264-master src
}

configure() {
  cd "${BUILD_DIR}/src"
  ./configure --prefix=/usr --enable-shared
}

build() {
  cd "${BUILD_DIR}/src"
  make -j"${ARTIX_MAKEFLAGS}"
}

package() {
  cd "${BUILD_DIR}/src"
  make DESTDIR="${PKG_DESTDIR}" install
}