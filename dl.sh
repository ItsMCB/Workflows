#!/bin/bash

# Styling
iconHarddrive='\U1F5B4'
iconFile='\U1F5CE'
iconCamera='\U1F4F9'
iconSpeaker='\U1F50A'

# Default formats
typeVideo="video"
typeAudio="audio"
commonFormat="%(title)s.%(ext)s"

# Set default variables
type="${typeVideo}"
videoExt="mp4"
audioExt="mp3"
downloadLocation="~/Desktop/"
outputFormat="%(title)s.%(ext)s"
includeMetadata="true"
extraMetadataFlags='--embed-metadata --add-metadata --xattrs --embed-thumbnail'
covert=""

# Functions

home() {
    prompt "What would you like to do?" "Download Video [V]\nDownload Audio [A]\nQuit [Q]"
    read -p "" ans;
    case $ans in
        v|v)
            type="${typeVideo}";;
        a|A)
            type="${typeAudio}";;
        *)
            exit;;
    esac
    dl
}

askVideoExt() {
    prompt "What target video extension?" "MP4 [Enter]\nOther [Input]"
    read -p "" ans;
    case $ans in
        ""|\n)
            videoExt="mp4";;
        *)
            videoExt=$ans;;
    esac
}

askAudioExt() {
    prompt "What target audio extension?" "MP3 [Enter]\nM4A [1]\nOther [Input]"
    read -p "" ans;
    case $ans in
        1|"1")
            audioExt="m4a";;
        ""|\n)
            audioExt=$audioExt;;
        *)
            audioExt=$ans;;
    esac
    prompt "Convert to another format?" "FLAC (lossless) [1]\nSkip/No [Enter]"
    read -p "" ans;
    case $ans in
        1|"1")
            covert="-x --audio-format flac";;
        *)
            ;;
    esac
}

askMetadata() {
    prompt "Include metadata?" "Yes [y]\nNo [n]"
    read -p "" ans;
    case $ans in
        y|Y|"y"|"Y")
            includeMetadata="true";;
        *)
            includeMetadata="false";;
    esac
}

askDownloadLocation() {
    prompt "Where should output file go?" "Desktop [1]\nOther [Input]"
    read -p "" ans;
    case $ans in
        1)
            downloadLocation="~/Desktop/";;
        *)
            downloadLocation=$ans;;
    esac
}

askOutputFormat() {
    prompt "How should the output file be formatted?" "${commonFormat} [1]\nOther [Input]"
    read -p "" ans;
    case $ans in
        1)
            outputFormat="${commonFormat}";;
        *)
            outputFormat="$ans";;
    esac
}

dl() {
    # Create final command args variable that will be appended to
    download=""
    # Check if type audio or video
    if [ "${type}" = "${typeVideo}" ]; then
        askVideoExt
        download="bestvideo[ext=${videoExt}]+bestaudio[ext=${audioExt}]/best[ext=${videoExt}]/best"
    else
        askAudioExt
        download="bestaudio[ext=${audioExt}]/bestaudio"
    fi
    # Check download location and output format
    askDownloadLocation
    askOutputFormat
    download="${download} -o ${downloadLocation}${outputFormat}"
    # Check if should include file metadata
    askMetadata
    if [ "${includeMetadata}" = "true" ]; then
        download="${download} ${extraMetadataFlags}"
    fi

    # Finally ask for content url
    printStatus
    prompt "What's the content URL?" "* [Input]"
    read -p "" url;
    download="${download} ${covert} ${url}"

    echo "Running the following command: 'yt-dlp -f ${download}'"
    yt-dlp -f ${download}
}

prompt() {
    printStatus
    echo ""
    echo "$1"
    echo ""
    echo "Options:"
    echo -e "$2"
}

printStatus() {
    clear
    echo -e "====== - YT-DLP Utility - ${iconHarddrive} ${downloadLocation} - ${iconFile} ${iconCamera} ${videoExt} - ${iconFile} ${iconSpeaker} ${audioExt} -======"
}

home
