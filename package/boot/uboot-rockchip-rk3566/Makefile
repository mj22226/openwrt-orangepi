#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=https://github.com/orangepi-xunlong/u-boot-orangepi
PKG_SOURCE_DATE:=2017-09
PKG_SOURCE_VERSION:=485cc4eae304d5f0bf2ea1456d6276fcd80158d5
PKG_MIRROR_HASH:=02b82bc5b8ecc7c35af87ef195685aed7b2f85dbbb4f59b59cdb1f0703e1b1e1

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk

define U-Boot/Default
  BUILD_TARGET:=rockchip
  UENV:=default
  HIDDEN:=1
endef


# RK3566 boards

define U-Boot/rk3566/Default
  BUILD_SUBTARGET:=armv8
  DEPENDS:=+PACKAGE_u-boot-$(1):arm-trusted-firmware-rk3566
  #PKG_BUILD_DEPENDS:=arm-trusted-firmware-rk3566
  ATF:=rk3568_bl31_v1.43.elf
  TPL:=rk3566_ddr_1056MHz_v1.18.bin
endef

define U-Boot/orangepi-3b-rk3566
  $(U-Boot/rk3566/Default)
  NAME:=Orange Pi 3B
  BUILD_DEVICES:= \
    xunlong_orangepi-3b
endef

define U-Boot/orangepi-cm4-rk3566
  $(U-Boot/rk3566/Default)
  NAME:=Orange Pi cm4
  BUILD_DEVICES:= \
    xunlong_orangepi-cm4
endef

UBOOT_TARGETS := \
  orangepi-3b-rk3566 \
  orangepi-cm4-rk3566

UBOOT_CONFIGURE_VARS += USE_PRIVATE_LIBGCC=yes

UBOOT_MAKE_FLAGS += \
  BL31=$(STAGING_DIR_IMAGE)/$(ATF) \
  spl/u-boot-spl.bin u-boot.dtb u-boot.itb

define Build/Configure
	$(call Build/Configure/U-Boot)

	$(SED) 's#CONFIG_MKIMAGE_DTC_PATH=.*#CONFIG_MKIMAGE_DTC_PATH="$(PKG_BUILD_DIR)/scripts/dtc/dtc"#g' $(PKG_BUILD_DIR)/.config
endef

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(PKG_BUILD_DIR)/tools/mkimage -n rk3568 -T rksd -d \
		$(STAGING_DIR_IMAGE)/$(TPL):$(PKG_BUILD_DIR)/spl/u-boot-spl.bin $(PKG_BUILD_DIR)/idbloader.img
	dd if=/dev/zero of=$(STAGING_DIR_IMAGE)/$(BUILD_VARIANT).bin bs=1k count=8192
	dd if=$(PKG_BUILD_DIR)/idbloader.img of=$(STAGING_DIR_IMAGE)/$(BUILD_VARIANT).bin seek=64 conv=notrunc
	dd if=$(PKG_BUILD_DIR)/u-boot.itb of=$(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-u-boot-rockchip.bin seek=16384 conv=notrunc
endef

define Package/u-boot/install/default
endef

$(eval $(call BuildPackage/U-Boot))
