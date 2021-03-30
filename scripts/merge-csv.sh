#!/usr/bin/env bash

# Prints usage help text
function usage {
  echo "Usage: merge-csv.sh <new-txt> <old-csv>"
  echo "  <new-txt>: text file containing skill name in each line"
  echo "  <old-csv>: old csv file containing translations"
}

# Not enough args
if [[ "$2" = "" ]]; then
  echo "merge-csv.sh – helper script to add new text fields from master.mdb"
  echo
  usage
  exit
fi

# Loop through each line in <new-text>
# awk used here to remove duplicates
cat "$1" | awk '!x[$0]++' | while read -r LINE; do
  # Try to find skill in <old-csv>
  # -F used here to match fixed strings (for `\n`s)
  TEXT="$(grep -F "\"$LINE\"" "$2" )"

  # Print it if found, print empty csv line otherwise
  if [[ "$TEXT" == "" ]]; then
    echo "\"$LINE\",\"\""
    continue
  fi
  echo "$TEXT"
done
