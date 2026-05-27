#!/usr/bin/env bash
pkgname=curl
pkgver=8.12.0
pkgrel=1
desc="Command line tool and library for transferring data with URL syntax"
url="https://curl.se"

sources=(
  "https://curl.se/download/curl-${pkgver}.tar.xz|SKIP|curl-${pkgver}.tar.xz"
)

depends=(openssl)
makedepends=(base-devel)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/curl-${pkgver}.tar.xz"
  mv "curl-${pkgver}" src
}

configure() {
  cd "${BUILD_DIR}/src"
  ./configure --prefix=/usr --with-openssl
}

build() {
  cd "${BUILD_DIR}/src"
  make -j"${ARTIX_MAKEFLAGS}"
}

package() {
  cd "${BUILD_DIR}/src"
  make DESTDIR="${PKG_DESTDIR}" install
}