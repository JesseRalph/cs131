#!/bin/bash

# We define shell function my_basename to isolate the last part of a URL
# Note: the pattern /$ matches a trailing /, if it exists
#       the pattern .*/ matches any number of characters followed by a slash
#       the pattern [.?].* matches any . or ? followed by any number of characters

my_basename () {
    URL="$1"
    BASENAME=$(echo "$URL" | sed -e 's#/$##' -e 's#.*/##' -e 's#[.?].*##')
    echo "$BASENAME"
}

# Check if a URL is provided as an argument to this script
if [ -z "$1" ]; then
    echo "Usage: $0 <URL of a csv or zip file>"
    echo "Example: $0 https://archive.ics.uci.edu/static/public/186/wine+quality.zip"
    exit 1
fi

URL="$1"

# We isolate the last part of the URL and use it as our file name.
BASENAME=$(my_basename "$URL")

# Create a directory named BASENAME, if it doesn't exist
if [ ! -d "$BASENAME" ]; then
    echo "Creating directory $BASENAME"
    mkdir "$BASENAME"
fi

# Move to that directory
echo "Moving to $BASENAME"
cd "$BASENAME"

# Attempt to download the data fromt the provided URL
curl -o "$BASENAME" "$URL"
if [ $? -eq 0 ]; then
    echo "Data downloaded successfully"
else
    echo "Could not download data from $URL"
    exit
fi

# Get abbreviated file data about the download using the file command

file_type_data=$(file -b "$BASENAME")

# Determine if it is a zip archive or an ASCII file
# If it's a zip archive, unzip
if echo "$file_type_data" | grep -q -i "zip"; then
    FILENAME="$BASENAME.zip"
    echo "Zip file found. Renaming to $FILENAME"
    mv "$BASENAME" "$FILENAME"
    echo "Unzipping..."
    unzip -u "$FILENAME"
elif echo "$file_type_data" | grep -q "ASCII"; then
    echo "ASCII file found, treating it as a csv file."
    FILENAME="$BASENAME.csv"
    echo "Renaming to $FILENAME"
    mv "$BASENAME" "$FILENAME"
else
    echo "Could NOT handle file $BASENAME"
    exit 1
fi

# We now iterate through all csv files in our working directory
for CSV_FILE in *.csv; do
    FIRST_PASS="TEMP.md"
    SUMMARY_FILE=$(echo "$CSV_FILE" | sed 's/\.csv/.md/')
    # We do a first pass, calculating min, max, mean, and displaying feature list
    awk -f ../summary_first_pass.awk "$CSV_FILE" > "$FIRST_PASS"    
    echo "-------------------------------------------------------"
    echo " Processing $CSV_FILE..."
    echo "-------------------------------------------------------"
    echo " Feature Index and Names"
    # Display feature list
    awk -F\; '{printf "%3d. %s\n", NR, $1}' "$FIRST_PASS"
    echo "-------------------------------------------------------"
    echo "Enter desired feature indices, separated by spaces, or press Enter to skip."
    read -a fields
    # Given user fields "x y z..."
    # We create a filter string for sed of the form "xp; yp; zp; ..."
    sed_filter=""
    sed_sep="p; "
    for field_index in "${fields[@]}"; do
        # Need to account for Summary output header
        real_index=$((field_index + 1))
        sed_filter+="$real_index$sed_sep"
    done
    
    # Generate second pass, calculating standard deviation
    awk -f ../summary_second_pass.awk "$FIRST_PASS" "$CSV_FILE" > "$SUMMARY_FILE"

    # If the user specified features, we use sed to print only those lines of our summary.
    # Otherwise, we cat the whole file.
    if [ -z "$sed_filter" ]; then
        cat "$SUMMARY_FILE"
    else
        sed -n "1p; $sed_filter" "$SUMMARY_FILE"
    fi
    #To keep the workspace neat, we remove the intermediate md file generated
    rm "$FIRST_PASS"
done
