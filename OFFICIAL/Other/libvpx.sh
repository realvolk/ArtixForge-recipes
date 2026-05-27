#!/usr/bin/env bash
pkgname=libvpx
pkgver=1.14.1
pkgrel=1
desc="VP8/VP9 video codec"
url="https://www.webmproject.org"

sources=(
  "https://github.com/webmproject/libvpx/archive/v${pkgver}.tar.gz|SKIP|libvpx-${pkgver}.tar.gz"
)

depends=()
makedepends=(base-devel)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/libvpx-${pkgver}.tar.gz"
  mv "libvpx-${pkgver}" src
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