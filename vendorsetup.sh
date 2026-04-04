# OrangeFox version options
# - This should, and can change between releases.
export FOX_VARIANT="6.6"
export FOX_MAINTAINER_PATCH_VERSION=

#
# Build vars that should be enabled during development.
export OF_SKIP_FBE_DECRYPTION=0

# OrangeFox options / build vars
# - This should not be changed between releases.
export FOX_TARGET_DEVICES="asteroids,Asteroids"

# dmsetup for wiping /data
export FOX_USE_DMSETUP=1

export FOX_VIRTUAL_AB_DEVICE=1
export FOX_VANILLA_BUILD=1
export FOX_ENABLE_APP_MANAGER=1
export FOX_USE_DATA_RECOVERY_FOR_SETTINGS=1
export FOX_ENABLE_KERNELSU_NEXT_SUPPORT=1
export FOX_ENABLE_SUKISU_SUPPORT=1
export FOX_DELETE_AROMAFM=1 # doesn't work
