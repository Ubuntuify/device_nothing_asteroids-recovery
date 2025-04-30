#!/vendor/bin/sh

#cp -rf /vendor/etc/sttesttool.json /data/nfc/sttesttool.json
cp -rf /vendor/etc/sttesttool.json /data/vendor/sttest/sttesttool.json
chmod 666 /data/vendor/sttest/sttesttool.json

if [ -f /sys/bus/i2c/devices/1-0008/hw_version ]; then
    hwid=`cat /sys/bus/i2c/devices/1-0008/hw_version`
    case "$hwid" in
        "ST54")
                setprop persist.vendor.nfc_mode_name "ST54"
                setprop persist.vendor.st_nfc_alwayson_ese 1
                ;;
        "ST21")
                setprop persist.vendor.nfc_mode_name "ST21"
                setprop persist.vendor.st_nfc_alwayson_ese 0
                ;;
        *)
                setprop persist.vendor.nfc_mode_name "0"
                setprop persist.vendor.st_nfc_alwayson_ese 0
    esac
fi
