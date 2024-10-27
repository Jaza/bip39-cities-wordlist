#!/bin/bash
set -e

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
CSV_FILENAME="csv/cities.csv"
CSV_FILEPATH=$(realpath "${SCRIPT_DIR}/../${CSV_FILENAME}")
TXT_FILENAME="cities.txt"
TXT_FILEPATH=$(realpath "${SCRIPT_DIR}/../${TXT_FILENAME}")

echo "Building ${TXT_FILENAME}"

cat $CSV_FILEPATH | tail -n +2 | awk -F "\"*,\"*" '{print $1}' > $TXT_FILEPATH

echo "Built!"

set +e
