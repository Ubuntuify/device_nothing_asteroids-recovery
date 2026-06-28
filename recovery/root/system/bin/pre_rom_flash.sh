SCRIPT_NAME="$(basename "$0")"

LOGMSG() {
  echo "I:$@" >>/tmp/recovery.log
}

LOGMSG "---$SCRIPT_NAME start---"
LOGMSG "---$SCRIPT_NAME end---"
