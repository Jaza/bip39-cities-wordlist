#!/bin/bash
set -e

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
CSV_FILENAME="csv/cities.csv"
CSV_FILEPATH=$(realpath "${SCRIPT_DIR}/../${CSV_FILENAME}")

echo "Verifying ${CSV_FILENAME}"

NUM_LINES=$(wc -l < $CSV_FILEPATH)
EXPECTED_NUM_LINES=2049

if [[ $NUM_LINES != $EXPECTED_NUM_LINES ]]; then
  >&2 echo "${CSV_FILENAME} contains ${NUM_LINES} lines but should be ${EXPECTED_NUM_LINES} lines"
  exit 1
fi

FIRST_LINE_CONTENTS=$(head -n 1 $CSV_FILEPATH)
EXPECTED_FIRST_LINE_CONTENTS="name,region,population,lat,lon"

if [[ $FIRST_LINE_CONTENTS != $EXPECTED_FIRST_LINE_CONTENTS ]]; then
  >&2 echo "First line of ${CSV_FILENAME} is \"${FIRST_LINE_CONTENTS}\" but should be \"${EXPECTED_FIRST_LINE_CONTENTS}\""
  exit 1
fi

CSV_LINE_REGEX="^[a-z]{4,12}\,[a-z \-]+\,[0-9]+\,\-?[0-9]+\.[0-9]+\,\-?[0-9]+\.[0-9]+$"

{
  read
  while read CSV_LINE; do
    if [[ ! $CSV_LINE =~ $CSV_LINE_REGEX ]]; then
      >&2 echo "Line \"${CSV_LINE}\" does not match regex \"${CSV_LINE_REGEX}\""
      exit 1
    fi
  done
} < $CSV_FILEPATH

DUPLICATES_REPORT_CONTENTS=$(cat $CSV_FILEPATH | tail -n +2 | cut -c1-4 | sort | uniq -cd)

if [[ -n "${DUPLICATES_REPORT_CONTENTS}" ]]; then
  >&2 echo "One or more cities have their first four letters identical, duplicates report is as follows:"
  >&2 echo "${DUPLICATES_REPORT_CONTENTS}"
  exit 1
fi

TEMP_DIR=$(realpath "${SCRIPT_DIR}/../temp")
mkdir -p $TEMP_DIR
TEMP_UNSORTED_CITIES_FILEPATH="${TEMP_DIR}/unsortedcities.txt"
TEMP_SORTED_CITIES_FILEPATH="${TEMP_DIR}/sortedcities.txt"

cat $CSV_FILEPATH | tail -n +2 | awk -F "\"*,\"*" '{print $1}' > $TEMP_UNSORTED_CITIES_FILEPATH
cat $CSV_FILEPATH | tail -n +2 | awk -F "\"*,\"*" '{print $1}' | sort > $TEMP_SORTED_CITIES_FILEPATH

SORTING_REPORT_CONTENTS=$(diff -u $TEMP_UNSORTED_CITIES_FILEPATH $TEMP_SORTED_CITIES_FILEPATH || :)

if [[ -n "${SORTING_REPORT_CONTENTS}" ]]; then
  >&2 echo "One or more cities are sorted incorrectly, sorting report is as follows:"
  >&2 echo "${SORTING_REPORT_CONTENTS}"
  exit 1
fi

TXT_FILENAME="cities.txt"
TXT_FILEPATH=$(realpath "${SCRIPT_DIR}/../${TXT_FILENAME}")

TXT_DIFF_REPORT_CONTENTS=$(diff -u $TEMP_SORTED_CITIES_FILEPATH $TXT_FILEPATH || :)

if [[ -n "${TXT_DIFF_REPORT_CONTENTS}" ]]; then
  >&2 echo "${CSV_FILENAME} differs from ${TXT_FILENAME}, diff report is as follows:"
  >&2 echo "${TXT_DIFF_REPORT_CONTENTS}"
  exit 1
fi

echo "Verified!"

set +e
