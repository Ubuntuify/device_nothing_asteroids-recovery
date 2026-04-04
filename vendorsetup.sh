# OrangeFox version options
# This should, and can change between releases.
export FOX_VARIANT="6.1"
export FOX_MAINTAINER_PATCH_VERSION=2

# OrangeFox Options
#
# According to documentation, all build variables that start with FOX should be exported
# as it will not be applied otherwise. For further reference, refer to the documentation
# of build variables.
#
# This should not be changed between releases unless necessary
export FOX_TARGET_DEVICES="asteroids,Asteroids"

export FOX_USE_DMSETUP=1 # dmsetup for wiping /data
export FOX_VIRTUAL_AB_DEVICE=1
export FOX_VANILLA_BUILD=1
export FOX_ENABLE_APP_MANAGER=1
export FOX_USE_DATA_RECOVERY_FOR_SETTINGS=1
export FOX_ENABLE_KERNELSU_NEXT_SUPPORT=1
export FOX_ENABLE_SUKISU_SUPPORT=1
export FOX_DELETE_AROMAFM=1 # doesn't work
