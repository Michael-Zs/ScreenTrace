#!/bin/bash

# 无论从哪里运行，都先进入当前脚本所在目录
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

SHOTS_PATH="shots/"
ARCHIVE_PATH="archive/"

# match time frome date-1, 4AM to date, 4AM
get_shots() {
  local date="${1:?Usage: get_shots YYYY-MM-DD}"
  local start end

  start="$(date -d "$date 04:00:00" '+%Y-%m-%d %H:%M:%S')" || return 1
  end="$(date -d "$date +1 day 04:00:00" '+%Y-%m-%d %H:%M:%S')" || return 1

  TMP_PATH="tmp-$1"

  mkdir $TMP_PATH

  find "$SHOTS_PATH" \
    -maxdepth 1 \
    -type f \
    -newermt "$start" \
    ! -newermt "$end" \
    -exec mv -t "$TMP_PATH" -- {} +

  tar -czvf $TMP_PATH.tar.gz $TMP_PATH/
  mkdir -p $ARCHIVE_PATH
  mv $TMP_PATH.tar.gz $ARCHIVE_PATH
  rm $TMP_PATH -r
}

if [[ -z $1 ]]; then
  echo "Usage: $0 2026-07-29"
  exit
fi

get_shots $1
