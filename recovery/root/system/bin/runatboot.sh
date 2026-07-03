#!/system/bin/sh

SCRIPT_NAME="$(basename "$0")"

LOGMSG() {
  echo "I:$@" >>/tmp/recovery.log
}

LOGMSG "---$SCRIPT_NAME start---"

LOGMSG "Resetting vibration HAL; it does not work when not reloaded properly.."

stop vendor.vibrator
start vendor.vibrator

LOGMSG "---$SCRIPT_NAME end---"
