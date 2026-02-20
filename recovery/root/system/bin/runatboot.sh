#!/system/bin/sh

insmod /lib/modules/qts.ko
insmod /lib/modules/goodix_ts.ko
insmod /lib/modules/focaltech_fts.ko

echo "[runatboot.sh] Loaded touchscreen modules successfully..." >/dev/kmsg
