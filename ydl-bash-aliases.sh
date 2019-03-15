#!/bin/bash
# ydl
if [ -x $(which youtube-dl) ] ; then
    alias ydl-F='youtube-dl -F'
    alias ydl-cmd='youtube-dl --restrict-filenames --no-mtime'
    alias ydl-mp4='youtube-dl --restrict-filenames --no-mtime -f 18'
    alias ydl-m4a='youtube-dl --restrict-filenames --no-mtime -f 140'
    alias ydl-video='youtube-dl --restrict-filenames --no-mtime -f 43'   # webm
    alias ydl-audio='youtube-dl --restrict-filenames --no-mtime -f 171'  # webm
    alias youtube-dl-upgrade='sudo -E youtube-dl -U'
    alias youtube-dl-upgrade-pip='sudo pip install --upgrade youtube-dl'
fi

# After downloading th video or audio file, the following functions/commands will
# boost the volume by a factor of 2.2. Above this value, audio quality deteriorates.
if [ -x  /usr/bin/ffmpeg ] ; then
    VOLUME2_DIR=~/Downloads/youtube/volume2
    function v2-video () {
        ffmpeg -v warning -i $1 -c:v copy -af volume=2.2 $VOLUME2_DIR/$(basename $1)
    }

    function v2-audio () {
        local f=$(basename $1)
        ffmpeg -v warning -i $1 -vn -af volume=2.2 $VOLUME2_DIR/${f%\.*}.ogg
    }
fi

