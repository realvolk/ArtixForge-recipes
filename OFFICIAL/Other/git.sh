#!/usr/bin/env bash
pkgname=git
pkgver=2.46.0
pkgrel=1
desc="Fast distributed version control system"
url="https://git-scm.com"

sources=(
  "https://www.kernel.org/pub/software/scm/git/git-${pkgver}.tar.xz|SKIP|git-${pkgver}.tar.xz"
)

depends=(curl expat openssl)
makedepends=(base-devel)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/git-${pkgver}.tar.xz"
  mv "git-${pkgver}" src
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