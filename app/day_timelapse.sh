#!/bin/sh

ffmpeg -framerate 24 -pattern_type glob -i '/app/pics/*_*_*_12_*.jpg' -c:v libx264 -pix_fmt yuv420p -strftime 1 "/app/pics/video_day_$(date +"%Y_%m_%d_%I_%M").mp4"
