#! /bin/bash

DIR_YTUBE=~/Downloads/youtube
DIR_SAVE=$DIR_YTUBE/volume2
CMD_BASE='youtube-dl --restrict-filenames '

function ffmpeg-volume2 () {
    ffmpeg -i "$1" -strict -2 -c:v copy -af volume=2.0 "$2"
}

function ydl-getfilename () {
    return "$($CMD_BASE --get-filename "$1")"
}

function ydl-ogg () {
    local dir1
    local vname
    local dlcmd="$CMD_BASE -f 140"   # download m4a
    # local dlcmd="$CMD_BASE -f 171"     # download webm
    vname=$($dlcmd --get-filename "$1")
    local title=${vname%-*}
    local ext=ogg
    local oname=$title.$ext
    dir1=$(pwd)
    
    echo "oname: $oname"

    cd $DIR_YTUBE || exit
    $dlcmd --no-mtime "$1"

    if (( $? )) ; then
        return 1;
    fi

    # increase the volume (x2.2)
    ffmpeg -i "$vname" -vn -af volume=2.2  "$oname"
    if (( $? )) ; then
        return 2;
    fi

    [ -d $DIR_SAVE ] && mv "$oname" $DIR_SAVE/
    [ -f "$vname" ] && rm -f "$vname"

    cd "$dir1" || exit
}

function ydl-audio () {
    local dir1
    local vname
    local dlcmd="$CMD_BASE -f 140"   # download m4a
    vname=$($dlcmd --get-filename "$1")
    local title=${vname%-*}
    local ext=${vname##*.}
    local oname=$title.$ext
    dir1=$(pwd)
    
    echo "oname: $oname"

    cd $DIR_YTUBE || exit
    $dlcmd --no-mtime "$1"

    if (( $? )) ; then
        return 1;
    fi

    # increase the volume (x2.2)
    ffmpeg -loglevel warning -i "$vname" -strict -2 -vn -af volume=2.2  "$oname"
    if (( $? )) ; then
        return 2;
    fi

    [ -d $DIR_SAVE ] && mv "$oname" $DIR_SAVE/
    [ -f "$vname" ] && rm -f "$vname"

    cd "$dir1" || exit
}

# '%(title)s|%(id)s.%(ext)s'
# --restrict-filenames
# --postprocessor-args '-strict -2 -af volume=2.2'
# -o '%(title)s-%(id)s.%(ext)s'
# --audio-format m4a

function ydl-video () {
    local dlcmd='youtube-dl --restrict-filenames -f 18'
    local vname
    vname=$($dlcmd --get-filename "$1")
    local title=${vname%-*}
    local ext=${vname##*.}
    local oname=$title.$ext

    # echo "oname: $oname"
    
    $dlcmd --no-mtime "$1"

    if (( $? )) ; then
        return 1;
    fi

    # increase the volume (x2)
    ffmpeg -loglevel warning -i $vname -strict -2 -c:v copy -af volume=2.2  $oname
    if (( $? )) ; then
        return 2;
    fi

    [ -d $DIR_SAVE ] && mv $oname $DIR_SAVE/
    [ -f $vname ] && rm -f $vname
}
