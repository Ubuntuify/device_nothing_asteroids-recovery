#!/system/bin/sh

# Taken from AzzyC's recovery tree, workaround SPL rollback protection. This usually causes a wipe
# to be ran when attempting to flash a custom ROM with a lower security patch date, which should always
# be the case.
#
# We want dirty flashes to work properly, so keep this on.

SCRIPT_NAME="$(basename "$0")"

LOGMSG() {
  echo "I:$@" >>/tmp/recovery.log
}

LOGMSG "---$SCRIPT_NAME start---"

LOGMSG "Resetting SPL date to prevent anti-rollback protection..."
resetprop ro.build.version.security_patch 2023-12-31

LOGMSG "---$SCRIPT_NAME end---"
