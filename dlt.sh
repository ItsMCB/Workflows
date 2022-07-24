#!/bin/bash

# Download Test.sh

# Style
iconHarddrive='\U1F5B4'
iconFile='\U1F5CE'
iconCamera='\U1F4F9'
iconSpeaker='\U1F50A'

# Variables
downloadArgs=""
includeVideo=false
includeAudio=false

includeMetadata=false
downloadLocation="~/Desktop/"
fileNameFormat="%(title)s.%(ext)s"

videoExt="mp4"
audioExt="mp3"

# Functions

home() {
    numeralPrompt "What are you downloading?" "Video" "Video w/ Metadata" "Audio" "Audio w/ Metadata" "Video+Audio" "Video+Audio w/Metadata" "Advanced" "Quit"
    read choice;
    echo "You said $choice"
    case $choice in
        1)
            includeVideo=true;
            download;;
        2)
            includeMetadata=true;
            includeVideo=true;
            download;;
        3)
            includeAudio=true;
            download;;
        4)
            includeMetadata=true;
            includeAudio=true;
            download;;
        5)
            includeAudio=true;
            includeVideo=true;
            download;;
        6) #AV w/MD
            includeMetadata=true;
            includeAudio=true;
            includeVideo=true;
            download;;
        7)
            advanced;;
        *)
            exit;;
    esac
}

numeralPrompt() {
    status
    echo "$1"
    echo "Options:"
    arr=("$@")
    for((i=1;i<=${#@}-1;i+=1));
    do 
        echo "  $i) ${arr[$i]}"
    done;
    echo "Numerical selection: "
}

featureWIPNotice() {
    numeralPrompt "Oops! That feature is WIP." "Return" "Quit"
    read choice;
    case $choice in
        1)
            home;;
        *)
            exit;;
    esac
}

advanced() {
    numeralPrompt "What to set?" "Target video extension" "Target audio extension" "Download location" "File format" "Return"
    read choice;
    case $choice in
        1)
            setTargetVideoExtension;;
        2)
            setTargetAudioExtension;;
        3)
            setDownloadLocation;;
        4)
            setFileNameFormat;;
        *)
            home;;
    esac
}

setTargetVideoExtension() {
    numeralPrompt "What target video extension?" "*"
    read choice;
    videoExt=$choice;
}

setTargetAudioExtension() {
    numeralPrompt "What target audio extension?" "*"
    read choice;
    audioExt=$choice;
}

setDownloadLocation() {
    numeralPrompt "What download location?" "*"
    read choice;
    downloadLocation=$choice;
}

setFileNameFormat() {
    numeralPrompt "What file name format?" "*"
    read choice;
    fileNameFormat=$choice
}

download() {
    status
    # AV
    if $includeVideo && $includeAudio;
    then
        downloadArgs="${downloadArgs} bestvideo[ext=${videoExt}]+bestaudio[ext=${audioExt}]/best[ext=${videoExt}]/best"
    else
        if $includeVideo;
        then
            downloadArgs="${downloadArgs} bestvideo[ext=${videoExt}]/best[ext=${videoExt}]/best"
        else
            downloadArgs="${downloadArgs} bestaudio[ext=${audioExt}]/bestaudio"
        fi
    fi
    # Metadata
    if $includeMetadata;
    then
        downloadArgs="${downloadArgs} --embed-metadata --add-metadata --xattrs --embed-thumbnail"
    fi
    downloadArgs="${downloadArgs} -o ${downloadLocation}${fileNameFormat}"
    echo "What's the content url?"
    read url;
    downloadArgs="${downloadArgs} ${url}"
    echo "Final args: $downloadArgs"
    yt-dlp -f ${downloadArgs}
    downloadArgs
    home

}

status() {
    echo -e "====== - YT-DLP Utility - ${iconHarddrive} ${downloadLocation} - ${iconFile} ${iconCamera} ${videoExt} - ${iconFile} ${iconSpeaker} ${audioExt} -======"
}

home