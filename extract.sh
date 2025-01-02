#!/bin/bash

# Check if the source directory is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <source_directory>"
    exit 1
fi

# Define the source directory and the output directory
source_dir="$1"  # The directory to search for files
output_dir="recovery/root"  # The directory to save extracted files
input_file="missing.txt"  # The file containing the list of file paths

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Read each line from the input file
while IFS= read -r entry; do
    # Skip empty lines and lines starting with # (comments)
    if [[ -z "$entry" || "$entry" == \#* ]]; then
        continue
    fi

    # Check if the entry contains a colon (:) to separate source and destination paths
    if [[ "$entry" == *:* ]]; then
        # Split the entry into source_path and destination_path
        source_path="${entry%%:*}"  # Everything before the colon
        destination_path="${entry##*:}"  # Everything after the colon
    else
        # If no colon, treat the entire entry as both source and destination paths
        source_path="$entry"
        destination_path="$entry"
    fi

    # Construct the full path to the source file in the source directory
    source_file="$source_dir/$source_path"
    
    # Check if the file exists in the source directory
    if [[ -f "$source_file" ]]; then
        # Create the directory structure in the output directory for the destination path
        mkdir -p "$output_dir/$(dirname "$destination_path")"
        
        # Copy the file to the output directory using the destination path
        cp "$source_file" "$output_dir/$destination_path"
        
        # Print a success message
        echo "Extracted: $source_path -> $destination_path"
    else
        # Print an error message if the file is not found
        echo "File not found in $source_dir: $source_path"
    fi
done < "$input_file"

# Print a completion message
echo "Extraction process completed. Files are stored in the '$output_dir' directory."
