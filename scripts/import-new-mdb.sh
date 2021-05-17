#!/usr/bin/env bash

# Prints usage help text
function usage {
  echo "Usage: import-new-mdb.sh <master-mdb-path>"
  echo "  <master-mdb-path> path to new master.mdb file"
}

function import {
  # $1: master-mdb-path
  # $2: csv-file-path
  # $3: category-id
  echo "==> Importing category $3 to $2…"

  TEMP_FILE=$(mktemp)
  TEMP_FILE_2=$(mktemp)
  QUERY="SELECT text FROM text_data WHERE category = $3"

  sqlite3 "$1" "$QUERY" > "$TEMP_FILE"
  ./scripts/merge-csv.sh "$TEMP_FILE" "$2" > "$TEMP_FILE_2"
  mv "$TEMP_FILE_2" "$2"

  rm "$TEMP_FILE"
}

# Not enough args
if [[ "$1" = "" ]]; then
  echo "import-new-mdb.sh – helper script to import new entries found in master.mdb"
  echo
  usage
  exit
fi

# Run series of imports
import "$1" "./src/data/uma-title.csv" "5"
import "$1" "./src/data/uma-name.csv" "6"
import "$1" "./src/data/item-name.csv" "23"
import "$1" "./src/data/item-desc.csv" "24"
import "$1" "./src/data/skill-name.csv" "47"
import "$1" "./src/data/skill-desc.csv" "48"
import "$1" "./src/data/trainer-title.csv" "65"
import "$1" "./src/data/trainer-title-requirements.csv" "66"
import "$1" "./src/data/missions.csv" "67"
import "$1" "./src/data/support-title.csv" "76"
import "$1" "./src/data/advice.csv" "97"
import "$1" "./src/data/uma-nickname.csv" "130"
import "$1" "./src/data/uma-nickname-requirements.csv" "131"
import "$1" "./src/data/pvp-raw-score-name.csv" "140"
import "$1" "./src/data/pvp-raw-score-desc.csv" "141"
import "$1" "./src/data/conditions-name.csv" "142"
import "$1" "./src/data/conditions-desc.csv" "143"
import "$1" "./src/data/pvp-score-bonus-name.csv" "148"
import "$1" "./src/data/story-event-missions.csv" "190"
