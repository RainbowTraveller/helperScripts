#!/bin/bash

DEST_DIR="/353605/images"
ZIP_CMD="zip -j"
UNDERSCORE="_"

HOST="saavnpl.upload.akamai.com"
USER="playlist_img_upload"
PASS="aHf5H3YJkw"
FTPLOG="./ftplog"
FTP_SUCCESS_MSG="226 Transfer complete"
FTP_SUCCESS=false

getgz() {

ftp -inv $HOST << GETGZ > $FTPLOG
    quote USER $USER
    quote PASS $PASS
    cd $1
    binary
    mget *gz
    quit
GETGZ

}

upload() {
echo "Inside upload $1" >> mytemp

for i in $(seq 1 3)
do
ftp -inv $HOST << UPLOAD > $FTPLOG
    quote USER $USER
    quote PASS $PASS
    cd $1
    binary
    put *.zip
    quit
UPLOAD

if fgrep "$FTP_SUCCESS_MSG" $FTPLOG ;then
    echo "ftp OK"
    FTP_SUCCESS=true
    break
fi
done

if [ "$FTP_SUCCESS" = false  ]; then
    main_dir="${2%/*}"
    echo "$main_dir" >> mytemp
    failed_dir="$main_dir/failed"
    echo "$failed_dir" >> mytemp
    mkdir "$failed_dir"
    mv $2/*gz $failed_dir
fi
}

cleanup() {
 rm -rf *jpg
 mv *gz targzfiles/
 mv *zip zipfiles/
}


createZip() {
    while true
    do
        local dir
        local finaldir
        local transfer
        local ftpdir

        for i in $(seq $1 $2)
        do
            if [ "$i" -lt 10 ]
            then
                ftpdir="$3/0$i"
            else
                ftpdir="$3/$i"
            fi
            for j in {0..1}
            do
                if [ "$j" -lt 10 ]
                then
                    finalftpdir="$ftpdir/0$j"
                else
                    finalftpdir="$ftpdir/$j"
                fi
                echo "FTP DIR : $finalftpdir" >> mytemp
                $(getgz $finalftpdir)
                for file in *tar.gz
                do
                    #mkdir /tmp/temptree
                    #tarcmd="tar -xzf $file -C /tmp/temptree"
                    #eval $tarcmd
                    #findcmd="find /tmp/temptree -type f -exec mv {} . \;"
                    #eval $findcmd
                    #rm -rf /tmp/temptree
                    tar -xzf $file
                done
                timestamp=$(date -u "+%Y-%m-%d_%H-%M-%S")
                zipper="$ZIP_CMD $i$UNDERSCORE$j-$timestamp *jpg"
                echo $zipper >> mytemp
                eval $zipper
                $(upload "/353605/images/qa") #Upload zip file to ftp
                $(cleanup) #delete transferring directory
            done
        done
        #sleep 60
        break
        exit 0
    done
}
$(createZip $1 $2 $DEST_DIR)
