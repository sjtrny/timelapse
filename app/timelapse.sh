#!/bin/sh
cd /app/pics
ffmpeg -rtsp_transport tcp -y -i rtsp://frigate:8554/greenhouse_record -frames:v 1 -update 1 -qscale:v 2 -f image2 -strftime 1 "$(date +"%Y_%m_%d_%I_%M").jpg"
