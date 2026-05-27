#!/usr/bin/env bash
pkgname=librewolf
pkgver=133.0
pkgrel=1
desc="Privacy-focused Firefox fork"
url="https://librewolf.net"

sources=(
  "https://gitlab.com/librewolf-community/browser/source.git|SKIP|librewolf-source"
)

depends=()
makedepends=(base-devel git cargo rust python mercurial)

feature_flags=()

prepare() {
  cd "${BUILD_DIR}"
  git clone --depth 1 --branch v${pkgver} "${sources[0]%%|*}" src
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