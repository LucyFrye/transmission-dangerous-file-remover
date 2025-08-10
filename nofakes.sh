#!/bin/bash

HOST="localhost:9091"
AUTH="YOUR_USERNAME:YOUR_PASSWORD"
BLOCKED_EXTS="exe zip rar iso scr xzip"
LOGFILE="/<YOUR_PATH_TO_THIS_SCRIPT>/nofakes.log"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"
}

TORRENTS=$(transmission-remote $HOST --auth $AUTH -l | tail -n +2 | head -n -1 | awk '{print $1}')

for TORRENT_ID in $TORRENTS; do
  # Get torrent name
  TORRENT_NAME=$(transmission-remote $HOST --auth $AUTH -t $TORRENT_ID --info | grep "Name:" | sed 's/Name: //')
  echo "Checking torrent $TORRENT_ID: $TORRENT_NAME"

  FILES=$(transmission-remote $HOST --auth $AUTH --torrent $TORRENT_ID --files)

  REMOVE_TORRENT=false
  BLOCKED_FILE=""

  while read -r line; do
    if [[ $line =~ ^[[:space:]]*([0-9]+):[[:space:]]+(.*)$ ]]; then
      FILENAME=${BASH_REMATCH[2]}
      for ext in $BLOCKED_EXTS; do
        if [[ "${FILENAME,,}" == *.$ext ]]; then
          BLOCKED_FILE="$FILENAME"
          REMOVE_TORRENT=true
          break 2
        fi
      done
    fi
  done <<< "$FILES"

  if $REMOVE_TORRENT; then
    log "Blocked file '$BLOCKED_FILE' found in torrent '$TORRENT_NAME' (ID $TORRENT_ID). Removing torrent and its data."
    echo "Removing torrent $TORRENT_ID and its data due to blocked files."
    transmission-remote $HOST --auth $AUTH --torrent $TORRENT_ID --remove-and-delete
  else
    echo "No blocked files found in torrent $TORRENT_ID"
  fi
done
