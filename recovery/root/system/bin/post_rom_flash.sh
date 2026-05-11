SCRIPT_NAME="$(basename "$0")"

LOGMSG() {
  echo "I:$@" >>/tmp/recovery.log
}

#
# Restore contents of /metadata because flashing a custom ROM seems to wipe it.
#

LOGMSG "---$SCRIPT_NAME start---"
LOGMSG "Restoring /metadata to ensure encryption and data still works after reboot."

mount /metadata
cp /tmp/metadata_backup/* /metadata

# Message about custom ROMs
echo "If you're coming from stock, use the included OrangeFox partition tools to switch your metadata partition to f2fs and vice versa."

LOGMSG "---$SCRIPT_NAME end---"
