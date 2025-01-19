#!/bin/bash

echo \
"
This script will:
1: Make you choose the input format
2: Make you choose the destination format and position of the converted images
3: Copy the new metadata (edit timestamp) into the new file

This script doesn't have any type of error handling, yet!
"

read -p "Press any key to proceed"

read -p "Choose the source format: " source_format
read -p "Choose the destination format: " new_format
read -p "Choose the destination (without the final /): " destination

for file in *.$source_format; do
    # Step 3
    orig_timestamp=$(stat -c "%Y" "$file")
    
    # Step 3.1
    touch -d "@$orig_timestamp" "$destination/${file%.$source_format}.$new_format"
done
