#
# Copyright (C) 2024 The Android Open Source Project
# Copyright (C) 2024 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/amethyst

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

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
    vendor \
    vendor_boot \
    vendor_dlkm

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/recovery/security/miui

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
	$(DEVICE_PATH) \
	vendor/qcom/opensource/commonsys-intf/display

# TWRP - Specifics
TW_THEME                := portrait_hdpi
TW_DEFAULT_LANGUAGE     := en
TW_USE_TOOLBOX          := true
TW_INCLUDE_NTFS_3G      := true
TW_INCLUDE_RESETPROP    := true
TW_INCLUDE_LIBRESETPROP := true
TW_MAX_BRIGHTNESS       := 2047
TW_EXTRA_LANGUAGES      := true
TW_DEFAULT_BRIGHTNESS   := 1020
TW_EXCLUDE_APEX         := true
TW_INCLUDE_FASTBOOTD    := true
TWRP_INCLUDE_LOGCAT     := true
TW_INCLUDE_PYTHON       := true
TW_NO_SCREEN_BLANK      := true
TW_FRAMERATE            := 60

# Blacklist Goodix fingerprint. There's no reason to include this input in recovery
TW_INPUT_BLACKLIST := "uinput-goodix"

TW_CUSTOM_CPU_TEMP_PATH := "/sys/class/thermal/thermal_zone7/temp"
TW_BRIGHTNESS_PATH      := "/sys/class/backlight/panel0-backlight/brightness"

# Vendor modules required for the recovery to function properly
TW_LOAD_VENDOR_MODULES  += "focaltech_ts_i2c.ko goodix_ts_9896.ko
TW_LOAD_VENDOR_MODULES  += adsp_loader_dlkm.ko qti_battery_charger.ko camera.ko"

TW_BATTERY_SYSFS_WAIT_SECONDS := 6
TW_EXCLUDE_DEFAULT_USB_INIT   := true
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true

TW_SUPPORT_INPUT_AIDL_HAPTICS := true
TW_SUPPORT_INPUT_AIDL_HAPTICS_FQNAME := "IVibrator/vibratorfeature"
TW_SUPPORT_INPUT_AIDL_HAPTICS_FIX_OFF := true

# TWRP - Crypto
TW_INCLUDE_CRYPTO               := true
TW_INCLUDE_CRYPTO_FBE           := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
BOARD_USES_QCOM_FBE_DECRYPTION  := true
PLATFORM_VERSION                := 99.87.36
PLATFORM_VERSION_LAST_STABLE    := $(PLATFORM_VERSION)

PLATFORM_SECURITY_PATCH := 2127-12-31
VENDOR_SECURITY_PATCH   := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH     := $(PLATFORM_SECURITY_PATCH)

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION  := false

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 := 
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := kryo300

# APEX
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := amethyst

# Bootloader
TARGET_NO_BOOTLOADER          := true
TARGET_USES_UEFI              := true

# Platform
TARGET_BOARD_PLATFORM         := volcano
TARGET_BOARD_PLATFORM_GPU     := qcom-adreno710
BOARD_USES_QCOM_HARDWARE      := true

# Kernel
BOARD_KERNEL_PAGESIZE         := 4096
TARGET_KERNEL_ARCH            := arm64
TARGET_KERNEL_HEADER_ARCH     := arm64
BOARD_KERNEL_IMAGE_NAME       := Image
BOARD_BOOT_HEADER_VERSION     := 4
TARGET_KERNEL_CLANG_COMPILE   := true
TARGET_PREBUILT_KERNEL        := /dev/null # empty kernel image
BOARD_MKBOOTIMG_ARGS          += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS          += --pagesize $(BOARD_KERNEL_PAGESIZE)

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 104857600
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor
BOARD_SUPER_PARTITION_SIZE := 9126805504 # TODO: Fix hardcoded value
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext product vendor vendor_dlkm odm
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 9122611200 # TODO: Fix hardcoded value

BOARD_PARTITION_LIST := $(call to-upper, $(BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := erofs))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))

BOARD_PARTITION_LIST += SYSTEM_DLKM
TARGET_COPY_OUT_SYSTEM_DLKM := system_dlkm

# device information for "fastboot update <zip-file>"
TARGET_BOARD_INFO_FILE := $(DEVICE_PATH)/board-info.txt

# GSI && GKI
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3 # disable hashtree/verification
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true

# Despite being VA/B device, there is a dedicated recovery partition
BOARD_USES_RECOVERY_AS_BOOT :=
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT :=

# Use LZ4 Ramdisk compression instead of GZIP
BOARD_RAMDISK_USE_LZ4 := true

# Power
ENABLE_CPUSETS    := true
ENABLE_SCHEDBOOST := true

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_VBMETA_SYSTEM := system
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1

# Allow for building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_USES_NETWORK := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_MISSING_REQUIRED_MODULES := true

# Platform
TARGET_BOARD_PLATFORM := volcano

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Security patch level
VENDOR_SECURITY_PATCH := 2021-08-01

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

# Hack: prevent anti rollback
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := 2099-12-31
PLATFORM_VERSION := 16.1.0

# TWRP Configuration
TW_THEME := portrait_hdpi
TW_EXTRA_LANGUAGES := true
TW_SCREEN_BLANK_ON_BOOT := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_USE_TOOLBOX := true
TW_INCLUDE_REPACKTOOLS := true

# Filesystems
TARGET_USERIMAGES_USE_EXT4    := true
TARGET_USERIMAGES_USE_F2FS    := true
TARGET_USES_MKE2FS            := true

# Workaround for error copying vendor files to recovery ramdisk
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

# System Properties
TARGET_SYSTEM_PROP := $(DEVICE_PATH)/system.prop

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab
TARGET_RECOVERY_QCOM_RTC_FIX := true
TARGET_USES_LOGD := true
