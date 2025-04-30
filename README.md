# WIP Nothing Phone (3a) device tree


## Works
* Screen
* Buttons

## Not works
* Touch (work after loading goodix_ts.ko focaltech_fts.ko manually from the ADB Shell)
* Vibration
* Data decryption
* hwservicemanager fails, because there's no vintf manifests yet
* recovery freezes, apparently the reason is above


```
source build/envsetup.sh
lunch fox_Asteroids-userdebug
mka adbd recoveryimage
```


## To start touchscreen
```
adb shell
mount -a
insmod /vendor_dlkm/lib/modules/goodix_ts.ko
insmod /vendor_dlkm/lib/modules/focaltech_fts.ko
```