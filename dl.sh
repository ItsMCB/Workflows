#!/bin/bash

# Set default variables
videoExt="mp4"
audioExt="m4a"
downloadLocation="~/Desktop/"
outputFormat="%(title)s.%(ext)s"
extraMetadataFlags='--embed-metadata --add-metadata --xattrs --embed-thumbnail'

# Functions
branding() {
    echo "===== YT-DLP DOWNLOAD UTILITY - ${USERNAME} ====="
}

home() {
    clear
    branding
    echo "1.) Download Video | V"
    echo "2.) Download Audio | A"
    echo "4.) Quit Program | Q"
    read -p "" ans;
    case $ans in
        v|v)
            downloadVideo;;
        a|A)
            downloadAudio;;
        *)
            clear
            exit;;
    esac
}

getVideoExt() {
    echo "Select target video format."
    echo "1.) MP4 | [Enter]"
    echo "2.) Other | *"
    read -p "" ans;
    case $ans in
        ""|\n)
            videoExt="mp4";;
        *)
            videoExt=$ans;;
    esac
    echo "Using video extension '${videoExt}'..."
}

getAudoExt() {
    echo "Select target audio format."
    echo "1.) M4A | [Enter]"
    echo "2.) Other | *"
    read -p "" ans;
    case $ans in
        ""|\n)
            audioExt="m4a";;
        *)
            audioExt=$ans;;
    esac
    echo "Using audio extension '${audioExt}'..."
}


downloadVideo() {
    getVideoExt
    echo "URL of video to download:"
    read -p "" ans;
    echo "Downloading best ${videoExt} format available. If there are none, find the best in another format."
    yt-dlp -f "bestvideo[ext=${videoExt}]+bestaudio[ext=${audioExt}]/best[ext=${videoExt}]/best" -o ${downloadLocation}${outputFormat} ${extraMetadataFlags} $ans
}

downloadAudio() {
    echo "Please provide a URL to be converted into an mp3"
    read -p "" ans;
    yt-dlp -f "bestaudio[ext=${audioExt}]/best" -o ${downloadLocation}${outputFormat} ${extraMetadataFlags} $ans
}

home