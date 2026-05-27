#!/usr/bin/env bash
pkgname=ffmpeg
pkgver=7.0
pkgrel=1
desc="Complete multimedia framework"
url="https://ffmpeg.org"

sources=(
  "https://ffmpeg.org/releases/ffmpeg-${pkgver}.tar.xz|SKIP|ffmpeg-${pkgver}.tar.xz"
)

depends=()
makedepends=(base-devel nasm yasm)

feature_flags=(
  x264
  x265
  vp9
  av1
)

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/ffmpeg-${pkgver}.tar.xz"
  mv "ffmpeg-${pkgver}" src
}

configure() {
  cd "${BUILD_DIR}/src"
  local opts=(--prefix=/usr)
  for f in "${selected_features[@]}"; do
    case "${f}" in
      x264) opts+=(--enable-libx264) ;;
      x265) opts+=(--enable-libx265) ;;
      vp9)  opts+=(--enable-libvpx) ;;
      av1)  opts+=(--enable-libaom) ;;
    esac
  done
  ./configure "${opts[@]}"
}

build() {
  cd "${BUILD_DIR}/src"
  make -j"${ARTIX_MAKEFLAGS}"
}

package() {
  cd "${BUILD_DIR}/src"
  make DESTDIR="${PKG_DESTDIR}" install
}