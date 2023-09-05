ffmpeg -framerate 24 -pattern_type glob -i '/app/pics/*.jpg' -c:v libx264 -pix_fmt yuv420p -strftime 1 "/app/output/full_$(date +"%Y_%m_%d_%I_%M").mp4"
