#
# Copyright (C) 2023 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2025 The OrangeFox Recovery Project
# SPDX-License-Identifier: GPL-3.0-or-later
#
#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2024-2025 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it


DEVICE_PATH := device/nothing/Asteroids

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_USES_NETWORK := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_MISSING_REQUIRED_MODULES := true

# A/B
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    init_boot \
    odm \
    product \
    recovery \
    system \
    system_dlkm \
    system_ext \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor \
    vendor_boot \
    vendor_dlkm

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 := 
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := kryo300
TARGET_BOARD_PLATFORM_GPU := qcom-adreno810

# APEX
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := volcano
TARGET_NO_BOOTLOADER := true

# Kernel/Ramdisk
BOARD_KERNEL_PAGESIZE         := 4096
TARGET_KERNEL_ARCH            := arm64
TARGET_KERNEL_HEADER_ARCH     := arm64
BOARD_KERNEL_IMAGE_NAME       := Image
BOARD_BOOT_HEADER_VERSION     := 4
TARGET_PREBUILT_KERNEL        := $(DEVICE_PATH)/prebuilt/kernel
BOARD_MKBOOTIMG_ARGS          += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS          += --pagesize $(BOARD_KERNEL_PAGESIZE)

# Graphics
TARGET_USES_VULKAN := true
HWUI_COMPILE_FOR_PERF := true

# Partitions
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

TARGET_COPY_OUT_ODM := odm
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USES_VENDOR_DLKMIMAGE := true
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

BOARD_BOOTIMAGE_PARTITION_SIZE := 0x6000000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x6400000
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 0x800000
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 0x6000000
BOARD_FLASH_BLOCK_SIZE := 131072

BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SUPER_PARTITION_SIZE := 9126805504 # TODO: Fix hardcoded value
BOARD_SUPER_PARTITION_GROUPS := nothing_dynamic_partitions
BOARD_NOTHING_DYNAMIC_PARTITIONS_PARTITION_LIST := odm product system system_dlkm system_ext vendor vendor_dlkm
BOARD_NOTHING_DYNAMIC_PARTITIONS_SIZE := 9122611200 # TODO: Fix hardcoded value

# Workaround for error copying vendor files to recovery ramdisk
TARGET_COPY_OUT_VENDOR := vendor

# Platform
TARGET_BOARD_PLATFORM := volcano
BOARD_USES_QCOM_HARDWARE := true

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Despite being VA/B device, there is a dedicated recovery partition
BOARD_USES_RECOVERY_AS_BOOT := 
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT :=

# GSI && GKI
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true

# Use LZ4 Ramdisk compression instead of GZIP
BOARD_RAMDISK_USE_LZ4 := true

# Board Info file
TARGET_BOARD_INFO_FILE := $(DEVICE_PATH)/board-info.txt

# Security patch level
VENDOR_SECURITY_PATCH := 2021-08-01

# Use mke2fs to create ext4 images
TARGET_USES_MKE2FS := true

# System Properties
TARGET_SYSTEM_PROP := $(DEVICE_PATH)/system.prop

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3 # disable hashtree/verification

# Encryption
BOARD_USES_METADATA_PARTITION := true
BOARD_USES_QCOM_FBE_DECRYPTION := true
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2199-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest.xml

# Hack: prevent anti rollback
PLATFORM_SECURITY_PATCH := 2199-12-31
VENDOR_SECURITY_PATCH := 2199-12-31
PLATFORM_VERSION := 16.1.0

# Sepolicy
BOARD_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy

