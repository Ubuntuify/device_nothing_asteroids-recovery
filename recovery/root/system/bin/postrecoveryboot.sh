#!/system/bin/sh

mount /vendor_dlkm

insmod /vendor_dlkm/lib/modules/goodix_ts.ko
insmod /vendor_dlkm/lib/modules/focaltech_fts.ko
