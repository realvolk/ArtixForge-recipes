#!/usr/bin/env bash
pkgname=linux-custom
_major=7
pkgver=7.0.10
pkgrel=1
desc="Linux kernel built from source (Artix base configuration)"
url="https://gitea.artixlinux.org/packages/linux"

sources=(
  "https://cdn.kernel.org/pub/linux/kernel/v${_major}.x/linux-${pkgver}.tar.xz|SKIP|linux-${pkgver}.tar.xz"
  "https://gitea.artixlinux.org/packages/linux/raw/branch/main/config.x86_64|SKIP|config.x86_64"
)

depends=()
makedepends=(base-devel bc cpio flex libelf pahole openssl)

feature_flags=(
  nvidia-support
  amd-support
)

prepare() {
  cd "${BUILD_DIR}"
  tar xf "${SOURCES_DIR}/linux-${pkgver}.tar.xz"
  mv "linux-${pkgver}" src
  cp "${SOURCES_DIR}/config.x86_64" "${BUILD_DIR}/config.x86_64"
}

configure() {
  cd "${BUILD_DIR}/src"

  if [[ -f "${BUILD_DIR}/config.x86_64" ]]; then
    cp "${BUILD_DIR}/config.x86_64" .config
    make olddefconfig
  else
    make allnoconfig
    scripts/config --enable 64BIT
    scripts/config --enable SMP
    scripts/config --enable BLOCK
    scripts/config --enable BLK_DEV
    scripts/config --enable PCI
    scripts/config --enable VIRTIO
    scripts/config --enable VIRTIO_MENU
    scripts/config --enable VIRTIO_PCI
    scripts/config --enable VIRTIO_BLK
    scripts/config --module USB_HID
    scripts/config --enable BLK_DEV_SD
    scripts/config --enable BLK_DEV_NVME
    scripts/config --enable ATA
    scripts/config --enable SATA_AHCI
    scripts/config --enable NET
    scripts/config --enable INET
    scripts/config --enable PACKET
    scripts/config --enable TTY
    scripts/config --enable VT
    scripts/config --enable UNIX98_PTYS
    scripts/config --enable PROC_FS
    scripts/config --enable SYSFS
    scripts/config --enable DEVTMPFS
    scripts/config --enable DEVTMPFS_MOUNT
    scripts/config --enable TMPFS
    scripts/config --enable BINFMT_ELF
    scripts/config --enable PRINTK
    scripts/config --enable MODULES
    scripts/config --enable MODULE_UNLOAD
  fi

  local depth
  depth="$(state_get KERNEL_CONFIG_DEPTH localmodconfig)"

  case "${depth}" in
    localmodconfig)
      make localmodconfig

      if [[ -f "${POWERUSER_DIR}/lib/kconfig.bash" ]]; then
        source "${POWERUSER_DIR}/lib/kconfig.bash"
        ensure_boot_essentials
      else
        scripts/config --enable BLOCK
        scripts/config --enable BLK_DEV
        scripts/config --enable VIRTIO
        scripts/config --enable VIRTIO_MENU
        scripts/config --enable VIRTIO_PCI
        scripts/config --enable VIRTIO_BLK
        scripts/config --enable BLK_DEV_SD
        scripts/config --enable BLK_DEV_NVME
        scripts/config --enable ATA
        scripts/config --enable SATA_AHCI
        scripts/config --enable DEVTMPFS
        scripts/config --enable DEVTMPFS_MOUNT
        scripts/config --enable NET
        scripts/config --enable INET
        scripts/config --enable PACKET
        scripts/config --enable TTY
        scripts/config --enable VT
        scripts/config --enable UNIX98_PTYS
        scripts/config --enable PROC_FS
        scripts/config --enable SYSFS
        scripts/config --enable TMPFS
        scripts/config --enable BINFMT_ELF
      fi

      local fs_type
      fs_type="$(state_get FS_TYPE ext4)"
      case "${fs_type}" in
        ext4)     scripts/config --enable EXT4_FS ;;
        btrfs)    scripts/config --enable BTRFS_FS ;;
        xfs)      scripts/config --enable XFS_FS ;;
        f2fs)     scripts/config --enable F2FS_FS ;;
        exfat)    scripts/config --enable EXFAT_FS ;;
        bcachefs) scripts/config --enable BCACHEFS_FS ;;
      esac

      for feat in "${selected_features[@]}"; do
        case "${feat}" in
          nvidia-support)
            scripts/config --module DRM_NOUVEAU
            scripts/config --enable DRM_NOUVEAU_BACKLIGHT
            ;;
          amd-support)
            scripts/config --module DRM_AMDGPU
            scripts/config --enable DRM_AMDGPU_SI
            scripts/config --enable DRM_AMDGPU_CIK
            ;;
        esac
      done

      yes "" | make oldconfig
      ;;

    menuconfig)
      if [[ -f "${POWERUSER_DIR}/lib/kconfig.bash" ]]; then
        source "${POWERUSER_DIR}/lib/kconfig.bash"
        apply_basic_config
        apply_advanced_config
      fi

      make menuconfig
      yes "" | make oldconfig
      ;;

    *)
      if [[ -f "${POWERUSER_DIR}/lib/kconfig.bash" ]]; then
        source "${POWERUSER_DIR}/lib/kconfig.bash"
        apply_basic_config
        apply_advanced_config
      fi

      local fs_type
      fs_type="$(state_get FS_TYPE ext4)"
      case "${fs_type}" in
        ext4) scripts/config --enable EXT4_FS ;;
        btrfs) scripts/config --enable BTRFS_FS ;;
        xfs) scripts/config --enable XFS_FS ;;
        f2fs) scripts/config --enable F2FS_FS ;;
        exfat) scripts/config --enable EXFAT_FS ;;
      esac

      for feat in "${selected_features[@]}"; do
        case "${feat}" in
          nvidia-support)
            scripts/config --module DRM_NOUVEAU
            scripts/config --enable DRM_NOUVEAU_BACKLIGHT
            ;;
          amd-support)
            scripts/config --module DRM_AMDGPU
            scripts/config --enable DRM_AMDGPU_SI
            scripts/config --enable DRM_AMDGPU_CIK
            ;;
        esac
      done

      yes "" | make oldconfig
      ;;
  esac
}

build() {
  cd "${BUILD_DIR}/src"
  make -j"${ARTIX_MAKEFLAGS}"
  make modules -j"${ARTIX_MAKEFLAGS}"
}

package() {
  cd "${BUILD_DIR}/src"
  make INSTALL_MOD_PATH="${PKG_DESTDIR}" modules_install
  mkdir -p "${PKG_DESTDIR}/boot"
  cp arch/x86/boot/bzImage "${PKG_DESTDIR}/boot/vmlinuz-linux-custom"
  cp .config "${PKG_DESTDIR}/boot/config-${pkgver}"
}