#!/usr/bin/env bash
pkgname=wlroots
pkgver=0.18.0
pkgrel=1
desc="Modular Wayland compositor library"
url="https://gitlab.freedesktop.org/wlroots/wlroots"

sources=(
  "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/${pkgver}/wlroots-${pkgver}.tar.gz|SKIP|wlroots-${pkgver}.tar.gz"
)

depends=(wayland-protocols)
makedepends=(base-devel meson ninja)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/wlroots-${pkgver}.tar.gz"
  mv "wlroots-${pkgver}" src
}

configure() {
  cd "${BUILD_DIR}"
  meson setup build src --prefix=/usr
}

build() {
  ninja -C "${BUILD_DIR}/build"
}

package() {
  DESTDIR="${PKG_DESTDIR}" ninja -C "${BUILD_DIR}/build" install
}