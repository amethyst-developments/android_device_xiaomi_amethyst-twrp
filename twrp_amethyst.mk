#
# Copyright (C) 2024 The Android Open Source Project
# Copyright (C) 2024 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from amethyst device
$(call inherit-product, device/xiaomi/amethyst/device.mk)

PRODUCT_DEVICE := amethyst
PRODUCT_NAME := twrp_amethyst
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := REDMI Note 14 Pro Plus
PRODUCT_MANUFACTURER := $(PRODUCT_BRAND)

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

#PRODUCT_BUILD_PROP_OVERRIDES += \
#    PRIVATE_BUILD_DESC="amethyst-user 14 UKQ1.240523.001 V816.0.20.0.UOPCNXM release-keys"

#BUILD_FINGERPRINT := Redmi/amethyst/amethyst:14/UKQ1.240523.001/V816.0.20.0.UOPCNXM:user/release-keys
