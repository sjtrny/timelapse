from datetime import datetime
import math
import os
import re
import shutil

import cv2
import ffmpeg
from tqdm import tqdm

def glob_re(pattern, working_dir):
    strings = os.listdir(working_dir)
    return list(filter(lambda x: re.match(pattern, x, flags = re.IGNORECASE), strings))

regex = "(\d{4}\_\d{2}\_\d{2})\_(1[0-6])\_\d{2}.jpg"
p = re.compile(regex)

var_threshold = 2000

pic_dir = "./data/pics"
tmp_dir = "./data/tmp"
tls_dir = "./data/timelapses"

# Nuke /out
if os.path.exists(tmp_dir) and os.path.isdir(tmp_dir):
    shutil.rmtree(tmp_dir)
os.mkdir(tmp_dir)

all_imgs = sorted(glob_re(regex, pic_dir))

for img_name in tqdm(all_imgs):
    img = cv2.imread(f"{pic_dir}/{img_name}")
    stat = cv2.Laplacian(img, cv2.CV_64F).var()
    if stat >= var_threshold:
        cv2.imwrite(f"{tmp_dir}/{img_name}", img)
    else:
        print("SKIPPING", img_name)

all_imgs = glob_re(regex, tmp_dir)

# Calculate length
n_frames = len(all_imgs)
fps = 30
orig_time = n_frames/fps
target_time = 5
window_nframes = max(1, math.ceil( orig_time/target_time ))

stream = ffmpeg.input(
    f'{tmp_dir}/*.jpg',
    pattern_type="glob",
    framerate=fps,
)

stream = ffmpeg.filter(
    stream,
    "tmix",
    **{
        'frames': window_nframes,
    }
)

stream = ffmpeg.filter(
    stream,
    "select",
    f"not(mod(n,{window_nframes}))"
)

stream = ffmpeg.filter(stream, 'setpts', f"PTS/{window_nframes}")

now = datetime.now()
stream = ffmpeg.output(
    stream,
    f"{tls_dir}/video_{now.strftime('%Y_%m_%d_%H_%M')}.mp4",
    format='mp4',
)

ffmpeg.run(stream)
