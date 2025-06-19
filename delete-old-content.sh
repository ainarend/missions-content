#!/bin/bash

# Safe script to preview deletion of riddle files older than 3 days
# Pattern: boy-{age}-{YYYY-MM-DD}.json or girl-{age}-{YYYY-MM-DD}.json

# Set to "true" to actually delete files, "false" for dry-run
DRY_RUN=true

# Calculate the cutoff date (3 days ago) - works on both macOS and Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    CUTOFF_DATE=$(date -v-3d '+%Y-%m-%d')
else
    # Linux
    CUTOFF_DATE=$(date -d '3 days ago' '+%Y-%m-%d')
fi

if [[ "$DRY_RUN" == "true" ]]; then
    echo "=== DRY RUN MODE - No files will be deleted ==="
else
    echo "=== LIVE MODE - Files will be deleted ==="
fi

echo "Files older than $CUTOFF_DATE will be processed..."
echo "Current date: $(date '+%Y-%m-%d')"
echo ""

# Counters
files_to_delete=0
files_to_keep=0

# Find and process files matching the pattern
for file in ./content/{boy,girl}-[2-8]-[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].json; do
    # Check if file exists (in case no files match the pattern)
    if [[ ! -f "$file" ]]; then
        continue
    fi
    
    # Extract the full date from filename (YYYY-MM-DD)
    # Pattern: {boy|girl}-{age}-YYYY-MM-DD.json
    # Remove prefix up to the age number, then extract YYYY-MM-DD
    temp="${file#*-*-}"  # Remove "boy-2-" or "girl-3-" etc.
    file_date="${temp%.json}"  # Remove ".json" to get YYYY-MM-DD
    
    # Compare dates
    if [[ "$file_date" < "$CUTOFF_DATE" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            echo "Would delete: $file (date: $file_date)"
        else
            echo "Deleting: $file (date: $file_date)"
            rm "$file"
        fi
        ((files_to_delete++))
    else
        echo "Keeping: $file (date: $file_date)"
        ((files_to_keep++))
    fi
done

echo ""
if [[ "$DRY_RUN" == "true" ]]; then
    echo "Summary: $files_to_delete files would be deleted, $files_to_keep files would be kept"
    echo ""
    echo "To actually delete the files, change DRY_RUN=false in the script"
else
    echo "Summary: $files_to_delete files deleted, $files_to_keep files kept"
fi
