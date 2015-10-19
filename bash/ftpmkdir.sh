#!/bin/bash


createDir() {
    local dir
    for i in {0..99}
    do
        if [ "$i" -lt 10 ]
        then
            dir="$@/0$i"
        else
            dir="$@/$i"
        fi
        #echo "mkdir $dir"
        for j in {0..99}
        do
            if [ "$j" -lt 10 ]
            then
                internaldir="$dir/0$j"
            else
                internaldir="$dir/$j"
            fi
            echo "mkdir $internaldir"
        done
    done

}
HOST="saavnpl.upload.akamai.com"
USER="playlist_img_upload"
PASS="aHf5H3YJkw"
DEST_DIR="353605/images/qa/"

ftp -n $HOST <<CREAT_DIR
quote USER $USER
quote PASS $PASS
$(createDir $DEST_DIR)
quit
CREAT_DIR

