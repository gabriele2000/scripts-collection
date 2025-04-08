#!/bin/bash

echo \
"
This script will deduplicate your video frames and make you choose the output folder
"

read -p "Press any key, this script will ask you things before proceeding"
read -p "Select the mode: 1 = deduplicate frames | 2 = change framerate and deduplicate " process_mode
read -p "Delete the source file after processing: 0 = No | 1 = Yes " post_process_delete

if [ $process_mode == 1 ]; then
    read -p "Choose the video codec: " video_codec
    read -p "Choose the destination (without the final /): " destination
    for file in *; do
        
        ffmpeg -i $file -c:v $video_codec -c:a copy \
        -vf "mpdecimate" \
        "$destination/$file"
        
        if [ $post_process_delete == 1 ]; then
            rm -rf  $file
        fi
    done
fi

if [ $process_mode == 2 ]; then
    read -p "Choose the video codec: " video_codec
    read -p "Choose the framerate " framerate
    read -p "Choose the destination (without the final /): " destination
    
    for file in *; do
        ffmpeg -i $file -c:v $video_codec -c:a copy \
        -r $framerate \
        "/tmp/$file"
        
        ffmpeg -i "/tmp/$file" -c:v $video_codec -c:a copy \
        -vf "mpdecimate" \
        "$destination/$file"
        
        rm -rf "/tmp/$file"
        
        if [ $post_process_delete == 1 ]; then
            rm -rf  $file
        fi
    done
fi
