#!/bin/sh

ffmpeg -framerate 24 -pattern_type glob -i '/app/data/pics/*.jpg' -c:v libx264 -pix_fmt yuv420p -strftime 1 "/app/data/timelapses/video_all_$(date +"%Y_%m_%d_%I_%M").mp4"
