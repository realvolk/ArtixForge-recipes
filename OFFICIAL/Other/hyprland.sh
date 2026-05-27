#!/usr/bin/env bash
pkgname=hyprland
pkgver=0.44.0
pkgrel=1
desc="Dynamic tiling Wayland compositor"
url="https://hyprland.org"

sources=(
  "https://github.com/hyprwm/Hyprland/archive/v${pkgver}.tar.gz|SKIP|hyprland-${pkgver}.tar.gz"
)

depends=(wayland-protocols wlroots)
makedepends=(base-devel meson ninja)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/hyprland-${pkgver}.tar.gz"
  mv "Hyprland-${pkgver}" src
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