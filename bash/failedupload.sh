#!/bin/bash

BASE_DIR="/Users/milind/tarzipplay"
DEST_DIR="/353605/images/qa"
FAILED="failed"
EXTENSION="tar.gz"
UNDERSCORE="_"

upload() {
echo "Inside upload $1 $2" >> mytemp
cur_dir=$(pwd)

HOST="saavnpl.upload.akamai.com"
USER="playlist_img_upload"
PASS="aHf5H3YJkw"
FTPLOG="./ftplog"
FTP_SUCCESS_MSG="226 Transfer complete"
FTP_SUCCESS=false

for i in $(seq 1 3)
do
ftp -inv $HOST << UPLOAD > $FTPLOG
    quote USER $USER
    quote PASS $PASS
    lcd $2
    cd $1
    binary
    put *
    quit
UPLOAD

if fgrep "$FTP_SUCCESS_MSG" $FTPLOG ;then
    echo "ftp OK"
    FTP_SUCCESS=true
    $(cleanup $2)
    break
fi
done

}

cleanup() {
 rm -rf "$1"
}


createZip() {
    while true
    do
        local dir
        local finaldir
        local failed
        local ftpdir

        for i in $(seq $2 $3)
        do
            if [ "$i" -lt 10 ]
            then
                dir="$1/0$i"
                ftpdir="$4/0$i"
            else
                dir="$1/$i"
                ftpdir="$4/$i"
            fi
            for j in {0..5}
            do
                if [ "$j" -lt 10 ]
                then
                    finaldir="$dir/0$j"
                    finalftpdir="$ftpdir/0$j"
                else
                    finaldir="$dir/$j"
                    finalftpdir="$ftpdir/$j"
                fi
                failed="$finaldir/$FAILED"
                echo "FTP DIR : $finalftpdir" >> mytemp
                echo "FAILED DIR : $failed" >> mytemp
                $(upload $finalftpdir $failed) #Upload zip file to ftp
            done
        done
        sleep 60
    done
}
$(createZip $BASE_DIR $1 $2 $DEST_DIR)
