#!/usr/bin/env bash
pkgname=dxvk
pkgver=2.5
pkgrel=1
desc="Vulkan-based D3D9/D3D10/D3D11 translation layer"
url="https://github.com/doitsujin/dxvk"

sources=(
  "https://github.com/doitsujin/dxvk/archive/v${pkgver}.tar.gz|SKIP|dxvk-${pkgver}.tar.gz"
)

depends=()
makedepends=(base-devel meson ninja glslang)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/dxvk-${pkgver}.tar.gz"
  mv "dxvk-${pkgver}" src
}

configure() {
  cd "${BUILD_DIR}/src"
  meson setup build --prefix=/usr
}

build() {
  ninja -C "${BUILD_DIR}/src/build"
}

package() {
  DESTDIR="${PKG_DESTDIR}" ninja -C "${BUILD_DIR}/src/build" install
}