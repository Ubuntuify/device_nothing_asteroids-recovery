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

# Maintainer name
OF_MAINTAINER := Ubuntuify

# Screen stuff
OF_SCREEN_H := 2400
OF_STATUS_H := 130
OF_STATUS_INDENT_LEFT := 48
OF_STATUS_INDENT_RIGHT := 48

# Other stuff
OF_QUICK_BACKUP_LIST := /boot;/data;
OF_ENABLE_LPTOOLS := 1
OF_NO_TREBLE_COMPATIBILITY_CHECK := 1
OF_ENABLE_FS_COMPRESSION := 1

# Number of list options before scrollbar creation
OF_OPTIONS_LIST_NUM := 9

# A/B with recovery partition
OF_AB_DEVICE_WITH_RECOVERY_PARTITION := 1
OF_VAB_ORS_WIPE_DATA_IS_FORMAT := 1

# Formatting userdata
OF_UNBIND_SDCARD_F2FS := 1
OF_WIPE_METADATA_AFTER_DATAFORMAT := 1  # Automatically wipe /metadata after data format
OF_BIND_MOUNT_SDCARD_ON_FORMAT := 1 # Prevent MTP issues after format
OF_USE_DMCTL := 1 # Dynamic partition fix for formatting

# Force casefolding with "F2FS" as data format
OF_FORCE_CASEFOLDING := 1
OF_FORCE_DATA_FORMAT_F2FS := 1

# Don't spam the console with loop errors
OF_LOOP_DEVICE_ERRORS_TO_LOG := 1

# lz4 compression
OF_USE_LZ4_COMPRESSION := 1

# Build all the partition tools
OF_ENABLE_ALL_PARTITION_TOOLS := 1

# Boot HAL is AIDL, and therefore this should be set to allow its proper usage
OF_USE_AIDL_BOOT_CONTROL := 1

# Use some CPU magic
ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# Enable the FRP reset addon
OF_ENABLE_FRP_ADDON := 1

# Time fixups
OF_USE_LEGACY_TIME_FIXUP := 1
