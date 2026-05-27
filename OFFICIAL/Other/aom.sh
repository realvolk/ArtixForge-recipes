#!/usr/bin/env bash
pkgname=aom
pkgver=3.10.0
pkgrel=1
desc="AV1 video codec"
url="https://aomedia.org"

sources=(
  "https://storage.googleapis.com/aom-releases/libaom-${pkgver}.tar.gz|SKIP|libaom-${pkgver}.tar.gz"
)

depends=()
makedepends=(base-devel cmake nasm)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/libaom-${pkgver}.tar.gz"
  mv "libaom-${pkgver}" src
}

configure() {
  cd "${BUILD_DIR}"
  cmake -S src -B build -DCMAKE_INSTALL_PREFIX=/usr
}

build() {
  cmake --build "${BUILD_DIR}/build" -j"${ARTIX_MAKEFLAGS}"
}

package() {
  cmake --install "${BUILD_DIR}/build" --prefix "${PKG_DESTDIR}/usr"
}