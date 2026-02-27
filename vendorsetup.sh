# OrangeFox version options
# - This should, and can change between releases.
export FOX_VARIANT="6.6"
export FOX_MAINTAINER_PATCH_VERSION=experimental

#
# Build vars that should be enabled during development.
export OF_SKIP_FBE_DECRYPTION=1

# OrangeFox options / build vars
# - This should not be changed between releases.
export FOX_TARGET_DEVICES="asteroids,Asteroids"

export FOX_VIRTUAL_AB_DEVICE=1
export FOX_VANILLA_BUILD=1
export FOX_ENABLE_APP_MANAGER=1
export FOX_USE_DATA_RECOVERY_FOR_SETTINGS=1
export FOX_ENABLE_KERNELSU_NEXT_SUPPORT=1
export FOX_ENABLE_SUKISU_SUPPORT=1
export FOX_DELETE_AROMAFM=1 # doesn't work
