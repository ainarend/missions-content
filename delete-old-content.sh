#!/bin/bash

# Script to delete riddle files older than 3 days
# Pattern: boy-{age}-{YYYY-MM-DD}.json or girl-{age}-{YYYY-MM-DD}.json

# Calculate the cutoff date (3 days ago)
CUTOFF_DATE=$(date -d '3 days ago' '+%Y-%m-%d')

echo "Deleting files older than $CUTOFF_DATE..."
echo "Current date: $(date '+%Y-%m-%d')"
echo ""

# Counter for deleted files
deleted_count=0

# Find and process files matching the pattern
for file in {boy,girl}-[2-8]-[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].json; do
    # Check if file exists (in case no files match the pattern)
    if [[ ! -f "$file" ]]; then
        continue
    fi
    
    # Extract date from filename using parameter expansion
    # Remove everything up to the last dash, then remove .json
    file_date_part="${file##*-}"
    file_date="${file_date_part%.json}"
    
    # Compare dates (string comparison works for YYYY-MM-DD format)
    if [[ "$file_date" < "$CUTOFF_DATE" ]]; then
        echo "Deleting: $file (date: $file_date)"
        rm "$file"
        ((deleted_count++))
    else
        echo "Keeping: $file (date: $file_date)"
    fi
done

echo ""
echo "Deleted $deleted_count files older than $CUTOFF_DATE"
