#!/bin/sh

RESOLUTION=1920x1080
MAX_IMAGES=365
DOWNLOAD_DIR=~/.cache/backsplash

mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR

curl -sL https://source.unsplash.com/random/$RESOLUTION -o newest
SUM=`sha256sum newest | cut -d ' ' -f 1`
if [ ! -f "$SUM" ]; then
	mv newest $SUM
else
	rm newest
fi

ls -1 | shuf | head -n -$MAX_IMAGES | xargs rm -f

ln -f `ls -1 | shuf | head -n 1` .wallpaper
killall swaybg
swaybg -m center -i .wallpaper
