#!/usr/bin/env bash
pkgname=libjxl
pkgver=0.10.0
pkgrel=1
desc="JPEG-XL image codec"
url="https://github.com/libjxl/libjxl"

sources=(
  "https://github.com/libjxl/libjxl/archive/v${pkgver}.tar.gz|SKIP|libjxl-${pkgver}.tar.gz"
)

depends=()
makedepends=(base-devel cmake)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/libjxl-${pkgver}.tar.gz"
  mv "libjxl-${pkgver}" src
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