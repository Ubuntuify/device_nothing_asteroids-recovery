SCRIPT_NAME="$(basename "$0")"

LOGMSG() {
  echo "I:$@" >>/tmp/recovery.log
}

LOGMSG "---$SCRIPT_NAME start---"

# Message about custom ROMs
echo "If you're coming from stock, use the included OrangeFox partition tools to switch your metadata partition to f2fs and vice versa."

LOGMSG "---$SCRIPT_NAME end---"
