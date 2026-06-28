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
#

# TWRP Configuration
TW_THEME := portrait_hdpi
TW_SCREEN_BLANK_ON_BOOT := true
TW_NO_INPUT_DEVICES := false
TW_INPUT_BLACKLIST := "null"

TW_MAX_BRIGHTNESS := 2048

TW_DEFAULT_LANGUAGE     := en
TW_USE_TOOLBOX          := true
TW_INCLUDE_NTFS_3G      := true
TW_INCLUDE_FUSE_EXFAT   := true
TW_INCLUDE_FUSE_NTFS    := true
TW_INCLUDE_REPACKTOOLS  := true
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_RESETPROP    := true
TW_EXTRA_LANGUAGES      := true
TW_EXCLUDE_APEX         := true
TW_INCLUDE_FASTBOOTD    := true

TW_LOAD_VENDOR_MODULES := "adsp_loader_dlkm.ko rproc_qcom_common.ko q6_dlkm.ko qcom_q6v5.ko qcom_q6v5_pas.ko qcom_sysmon.ko focaltech_fts.ko hapticdrv.ko"
TW_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true

# Haptics / Vibrations
TW_SUPPORT_INPUT_AIDL_HAPTICS := true
TW_SUPPORT_INPUT_AIDL_HAPTICS_FQNAME := "IVibrator/default"
TW_SUPPORT_INPUT_AIDL_HAPTICS_FIX_OFF := true

# USB
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true

# Little hack (some reason libhardware.so isn't ending up compiled)
TARGET_RECOVERY_DEVICE_MODULES += \
    android.hidl.allocator@1.0 \
    android.hidl.memory@1.0 \
    android.hidl.memory.token@1.0 \
    libdmabufheap \
    libhidlmemory \
    libhardware \
    libion \
    libnetutils \
    vendor.display.config@1.0 \
    vendor.display.config@2.0 \
    libdebuggerd_client
TW_OVERRIDE_SYSTEM_PROPS := \
    "ro.build.product;ro.build.fingerprint=ro.vendor.build.fingerprint;ro.build.version.incremental"
TW_OVERRIDE_PROPS_ADDITIONAL_PARTITIONS := vendor
RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hidl.allocator@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hidl.memory@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hidl.memory.token@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libdmabufheap.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libhidlmemory.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libnetutils.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libdebuggerd_client.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@1.0.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@2.0.so
TW_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true
TW_FRAMERATE := 120
TW_HAS_EDL_MODE := true

# TWRP - Encryption / Decryption
TW_INCLUDE_CRYPTO               := true
TW_INCLUDE_CRYPTO_FBE           := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
BOARD_USES_QCOM_FBE_DECRYPTION  := true

# Debug
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
TARGET_RECOVERY_DEVICE_MODULES += debuggerd
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/debuggerd
TARGET_RECOVERY_DEVICE_MODULES += strace
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/strace
