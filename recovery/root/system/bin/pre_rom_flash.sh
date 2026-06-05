SCRIPT_NAME="$(basename "$0")"

LOGMSG() {
  echo "I:$@" >>/tmp/recovery.log
}

#
# Backup contents of /metadata because flashing a custom ROM seems to wipe it.
#

LOGMSG "---$SCRIPT_NAME start---"
LOGMSG "---$SCRIPT_NAME end---"
