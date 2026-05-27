#!/usr/bin/env bash
pkgname=gnupg
pkgver=2.4.7
pkgrel=1
desc="GNU Privacy Guard"
url="https://gnupg.org"

sources=(
  "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-${pkgver}.tar.bz2|SKIP|gnupg-${pkgver}.tar.bz2"
)

depends=(libgcrypt)
makedepends=(base-devel)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/gnupg-${pkgver}.tar.bz2"
  mv "gnupg-${pkgver}" src
}

configure() {
  cd "${BUILD_DIR}/src"
  ./configure --prefix=/usr
}

build() {
  cd "${BUILD_DIR}/src"
  make -j"${ARTIX_MAKEFLAGS}"
}

package() {
  cd "${BUILD_DIR}/src"
  make DESTDIR="${PKG_DESTDIR}" install
}