#!/bin/bash

cd wine+quality
for CSV_FILE in *.csv; do
    INTERMEDIATE_SUMMARY_FILE="TEMP.md"
    SUMMARY_FILE=$(echo "$CSV_FILE" | sed 's/\.csv/.md/')
    awk -f ../summary_first_pass.awk "$CSV_FILE" > "$INTERMEDIATE_SUMMARY_FILE"
    awk -f ../summary_second_pass.awk "$INTERMEDIATE_SUMMARY_FILE" "$CSV_FILE" > "$SUMMARY_FILE"
    cat "$INTERMEDIATE_SUMMARY_FILE"
    cat "$SUMMARY_FILE"
    rm "$INTERMEDIATE_SUMMARY_FILE"
    rm "$SUMMARY_FILE"
    #   A list of all features (columns) with the index number
    #   min/max/mean/standard deviation for numerical columns in a table format
    #   the option for the user to identify features (column indices)
    #   -the option to enter indices will be after the list of all features is displayed.
done
