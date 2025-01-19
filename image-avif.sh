#!/bin/bash

echo \
"
This script will:
1: Ask you the input format
2: Make you choose the destination of the converted images
3: Convert any image format into AVIF
4: Copy the new metadata (edit timestamp) into the new file

This script doesn't have any type of error handling, yet!
"
read -p "Press any key to proceed"

read -p "Choose the input format: " input_format
read -p "Choose the destination (without the final /): " destination
read -p "Choose the threads number" threads

for file in *.$input_format; do
    # Step 3
    avifenc -s 4 -j $threads --min 16 --max 20 -a tune=ssim "$file" "$destination/${file%.$input_format}.avif"
    
    # Step 4.0
    orig_timestamp=$(stat -c "%Y" "$file")
    
    # Step 4.1
    touch -d "@$orig_timestamp" "$destination/${file%.$input_format}.avif"
done
