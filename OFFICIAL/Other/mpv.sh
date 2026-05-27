#!/usr/bin/env bash
pkgname=mpv
pkgver=0.38.0
pkgrel=1
desc="Video player based on MPlayer/mplayer2"
url="https://mpv.io"

sources=(
  "https://github.com/mpv-player/mpv/archive/v${pkgver}.tar.gz|SKIP|mpv-${pkgver}.tar.gz"
)

depends=(ffmpeg)
makedepends=(base-devel meson ninja)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/mpv-${pkgver}.tar.gz"
  mv "mpv-${pkgver}" src
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