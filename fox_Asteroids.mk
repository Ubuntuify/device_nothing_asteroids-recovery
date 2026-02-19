#
# Copyright (C) 2025 The Android Open Source Project
# Copyright (C) 2025 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)


DEVICE_PATH := device/nothing/Asteroids

# Inherit from Asteroids device
$(call inherit-product, $(DEVICE_PATH)/device.mk)

# Include TWRP props
$(call inherit-product, $(DEVICE_PATH)/twrp.mk)

# Include Fox props
$(call inherit-product, $(DEVICE_PATH)/fox.mk)

PRODUCT_DEVICE := Asteroids
PRODUCT_NAME := fox_Asteroids
PRODUCT_BRAND := Nothing
PRODUCT_MODEL := A059
PRODUCT_MANUFACTURER := nothing

PRODUCT_GMS_CLIENTID_BASE := android-nothing

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="Asteroids-user 14 UKQ1.241011.001 2503021856 release-keys"

BUILD_FINGERPRINT := Nothing/Asteroids/Asteroids:14/UKQ1.241011.001/2503021856:user/release-keys

# some stuff
OF_DEFAULT_KEYMASTER_VERSION := 4.0
OF_USE_AIDL_BOOT_CONTROL := 1
OF_NO_TREBLE_COMPATIBILITY_CHECK := 1
OF_USE_DMCTL := 1
