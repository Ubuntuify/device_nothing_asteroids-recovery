SCRIPT_NAME="$(basename "$0")"

LOGMSG() {
  echo "I:$@" >>/tmp/recovery.log
}

#
# Backup contents of /metadata because flashing a custom ROM seems to wipe it.
#

LOGMSG "---$SCRIPT_NAME start---"
LOGMSG "Backing up /metadata to ensure encryption still works after reboot."

# Make sure /metadata is mounted, this should use the fstab
mount /metadata

# Make backup folder, then copy contents
mkdir -p /tmp/metadata_backup
cp /metadata/* /tmp/metadata_backup/*

LOGMSG "---$SCRIPT_NAME end---"
