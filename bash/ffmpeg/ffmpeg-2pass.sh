#!/bin/sh
#
# Simple two-pass conversion script for ffmpeg
#
let h=2       #hours
let m=15      #minutes
let s=19      #seconds
let a_b=192   #audio bitrate
let size=2048 #target file size
INPUT=path/to/input.mkv 
OUTPUT=/path/to/output.mkv

#Less often changed settings
MAX_CORES=4        #max num of cpu threads to use
SUBTITLE_CODEC=srt #MKV: copy, ass, srt, ssa #MP4/MOV : copy, mov_text
AUDIO_CODEC=aac    #aac, ac3, ac3_fixed, flac, opus
PRESET=slow        #veryslow, slower, slow, medium, fast, faster, veryfast, superfast, ultrafast
FORMAT=matroska    #matroska, mp4, avi, flv etc: https://ffmpeg.org/ffmpeg-formats.html#Muxers

# Auto calc some values
let ksize=size*8192
let runtime=m*60+h*60*60+s
let v_b=ksize/runtime-a_b

echo "Running 2-pass ffmpeg conversion for: $INPUT"
echo "  Output: $OUTPUT"
echo "  Length: ${runtime} seconds (${h}:${m}:${s})"
echo "  Audio Bitrate: $a_b"
echo "  Video Bitrate: $v_b"
echo "  Target final size: ${size}MB"

echo "Using the following commands:"
echo "ffmpeg -y -i $INPUT -c:v libx264 -b:v ${v_b}k -pass 1 -an -f ${FORMAT} /dev/null && \\"
echo "ffmpeg -i $INPUT -c:v libx264 -b:v ${v_b}k -pass 2 -c:a ${AUDIO_CODEC} -b:a ${a_b}k -scodec ${SUBTITLE_CODEC} -threads ${MAX_CORES} -preset ${PRESET} -strict -2 $OUTPUT"

read -p "Are you sure? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
ffmpeg -y -i $INPUT -c:v libx264 -b:v ${v_b}k -pass 1 -an -f $FORMAT /dev/null && \
ffmpeg -i $INPUT -c:v libx264 -b:v ${v_b}k -pass 2 -c:a $AUDIO_CODEC -b:a ${a_b}k -scodec $SUBTITLE_CODEC -threads $MAX_CORES -preset $PRESET -strict -2 $OUTPUT
fi
