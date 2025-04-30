#! /vendor/bin/sh

oem_sec_boot=`cat /proc/nothing_secure/oem_sec_boot`

if [ $oem_sec_boot -eq 0 ]
then
  echo "[oem_sec_boot] oem_sec_boot is non secure" > /dev/kmsg
  setprop vendor.oem_sec_boot 0
elif [ $oem_sec_boot -eq 1 ]
then
  echo "[oem_sec_boot] oem_sec_boot is development stage" > /dev/kmsg
  setprop vendor.oem_sec_boot 1
elif [ $oem_sec_boot -eq 2 ]
then
  echo "[oem_sec_boot] oem_sec_boot is product stage" > /dev/kmsg
  setprop vendor.oem_sec_boot 2
else
  setprop vendor.oem_sec_boot 2
  echo "[oem_sec_boot] /proc/nothing_secure/oem_sec_boot is not valid, set vendor.oem_sec_boot as 2" > /dev/kmsg
fi
