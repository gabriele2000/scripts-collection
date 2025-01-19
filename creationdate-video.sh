#!/bin/bash

echo \
"
This script will duplicate the video and will append the metadata from the original file
It'll also:
1: Ask you the source format
2: Ask you the new format
3: Make you choose the location of the new videos
4: Analyze the file and get the creation timestamp
5: Place the timestamp into a new duplicate file, in a choosen folder

This script doesn't have any type of error handling, yet!
"
read -p "Press any key to proceed"

read -p "Choose the format of the original videos: " source_format
read -p "Choose the format of the new videos: " new_format
read -p \
"
Make sure the new videos are in the same folder of the original one, a duplicated will be created in the destination folder.
Choose the location when the new duplicates will be saved (without the final /): " destination

for file in *.$source_format; do
    # Step 4
    ffprobe -v error -select_streams v:0 -show_entries format_tags=creation_time -of csv=p=0 "$file" > creation_time.txt
    
    # Step 5
    ffmpeg -i "${file%.$source_format}.$new_format" \
           -metadata creation_time="$(cat creation_time.txt)" \
           -codec copy "$destination/${file%.$source_format}.$new_format"
done

rm creation_time.txt
