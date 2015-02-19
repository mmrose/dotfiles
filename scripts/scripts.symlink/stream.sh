#!/bin/bash

# USAGE for video.mp4 with video bitrates 100, 200 and 300 kbit/s and audio bitrate 64kbit/s
# ./stream.sh /path/to/video/video.mp4 rtmp://thepubpoint/live 100,200,300 64 "stream1?key&adbe-live-event=theevent;stream2?key&adbe-live-event=theevent;stream3?key&adbe-live-event=theevent;"

VIDEO_FILE=$1
PUBLISHING_POINT=$2
VIDEO_BITRATES=$3
AUDIO_BITRATE=$4
STREAM_INFO=$5

FOLDER_VIDEO=$(dirname "${VIDEO_FILE}")
VIDEO_FILE=$(basename "${VIDEO_FILE}")

cd ${FOLDER_VIDEO}

# split stream string to separate streams
IFS=';' read -a streams <<< "${STREAM_INFO}"
# same for video bitrates
IFS=',' read -a video_rates <<< "${VIDEO_BITRATES}"

cmd=""
for stream_idx in "${!streams[@]}"
do
    cmd="${cmd} -c:v libx264 -b:v ${video_rates[stream_idx]}k -c:a libvo_aacenc -b:a ${AUDIO_BITRATE}k  -ac 2 -f flv ${PUBLISHING_POINT}/${streams[stream_idx]}"
done

cmd="ffmpeg -re -i ${VIDEO_FILE} -loop 100 ${cmd}"

while sleep 1; do
    ${cmd}
done