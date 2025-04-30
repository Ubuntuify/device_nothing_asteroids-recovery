#! /vendor/bin/sh
#=============================================================================
# Copyright (c) 2024 Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#=============================================================================

DIR=/sys/devices/platform/soc/23049000.qcom,ethernet/net/eth1

echo "Early_eth start." > /dev/kmsg

while true
do
    if [ -d "$DIR" ]
    then
        echo "Folder /sys/devices/.../eth1 is created." > /dev/kmsg
        ifconfig eth1 192.168.2.3 up
        break
    fi
    sleep 0.05
done

echo "Early_eth done." > /dev/kmsg
