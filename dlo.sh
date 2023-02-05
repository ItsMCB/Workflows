# Download OPUS

# var
content_url="";


home() {
    echo ""
    echo "Hello, ${USER}!"
    echo "This script helps you download music to .opus with metadata."
    echo "============================================"
    echo "What is the URL of the content you wish to download?"
    read -p "" content_url;
    download
}

download() {
    yt-dlp -x --audio-quality 0 --embed-thumbnail --add-metadata -o "~/Desktop/%(title)s.%(ext)s" $content_url
}

home