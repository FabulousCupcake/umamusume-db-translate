#!/usr/bin/env bash

# trainer-title-requirements.csv contains a lot of duplicates from missions.csv
# But sometimes linebreaks are removed, so we can't simply remove/ignore them

# This script basically tries to translate trainer-title-requirements.csv with
# translations that already exist in missions.csv

# Prints usage help text
function usage {
  echo "Usage: trainer-title-requirements-tl.sh <trainer-title-requirements.csv> <missions.csv> "
  echo "  <trainer-title-requirements.csv> path to trainer-title-requirements.csv file"
  echo "  <missions.csv>                   path to missions.csv file"
}

# Not enough args
if [[ "$2" = "" ]]; then
  echo "trainer-title-requirements-tl.sh"
  echo "A helper script to import missions.csv translations to trainer-title-requirements.csv"
  echo
  usage
  exit
fi

TEMP_FILE=$(mktemp)

# Add contents of missions.csv to TEMP_FILE
cat "$2" > "$TEMP_FILE"

# Add contents of missions.csv again, but without linebreaks, to TEMP_FILE
cat "$2" | sed 's/\\n//g' >> "$TEMP_FILE"

# Loop through each line in <trainer-title-requirements.csv>
# Remove \n and put it to TEMP_FILE
IFS=
cat "$1" | awk '!x[$0]++' | while read -r LINE; do
  # Just write it if already translated
  TEXT="$(grep -F '",""' <<< "$LINE")"
  if [[ "$TEXT" == "" ]]; then
    echo "$LINE"
    continue
  fi

  # Get only the text
  TEXT="$(sed 's/",""//' <<< "$TEXT")"
  TEXT="$(sed 's/"//' <<< "$TEXT")"

  # Try to find skill in TEMP_FILE
  # -F used here to match fixed strings (for `\n`s)
  MATCH="$(grep -F "\"$TEXT\"" "$TEMP_FILE")"

  # Print it if found, print empty csv line otherwise
  if [[ "$MATCH" == "" ]]; then
    echo "$LINE"
    continue
  fi
  echo "$MATCH"
done

rm "$TEMP_FILE"
