#!/usr/bin/env bash
pkgname=firefox
pkgver=133.0
pkgrel=1
desc="Mozilla Firefox web browser"
url="https://firefox.com"

sources=(
  "https://archive.mozilla.org/pub/firefox/releases/${pkgver}/source/firefox-${pkgver}.source.tar.xz|SKIP|firefox-${pkgver}.tar.xz"
)

depends=()
makedepends=(base-devel rust cargo python nodejs nasm)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/firefox-${pkgver}.tar.xz"
  mv "firefox-${pkgver}" src
}

configure() {
  cd "${BUILD_DIR}/src"
  ./mach configure --prefix=/usr
}

build() {
  cd "${BUILD_DIR}/src"
  ./mach build
}

package() {
  cd "${BUILD_DIR}/src"
  ./mach install --destination "${PKG_DESTDIR}"
}