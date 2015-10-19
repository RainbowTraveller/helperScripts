#!/bin/bash

BASE_DIR="tarzipplay"
DEST_DIR="353605/images/qa"
TRANSFERRING="transferring"
EXTENSION="tar.gz"
TAR_CMD="tar vfcz "
UNDERSCORE="_"

upload() {

HOST="saavnpl.upload.akamai.com"
USER="playlist_img_upload"
PASS="aHf5H3YJkw"

#ftp -n $HOST <<UPLOAD
#quote USER $USER
#quote PASS $PASS
#cd $1
#echo "put $2/*" >> mytemp
#quit
#UPLOAD
echo "put $2/*tar.gz" >> mytemp
}

cleanup() {
 echo "rm -rf $1" >> mytemp
}



createZip() {
    local dir
    local finaldir
    local transfer
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
            #Create Transferring dir and copy files to transferring directory
            transfer="$finaldir/$TRANSFERRING"
            echo "mkdir $transfer" >> mytemp
            echo "mv $finaldir/*.jpg $transfer" >> mytemp
            timestamp=$(date -u "+%Y-%m-%d_%H:%M:%S")
            #zipper="$TAR_CMD ~/$finaldir/$i$UNDERSCORE$j-$timestamp.$EXTENSION --exclude='*.tar.gz' ~/$finaldir/*" # W/O transferring directory
            zipper="$TAR_CMD ~/$transfer/$i$UNDERSCORE$j-$timestamp.$EXTENSION --exclude='*.tar.gz' ~/$transfer/*"
            echo $zipper >> mytemp
            echo "FTP : $finalftpdir" >> mytemp
            $(upload $finalftpdir $transfer) #Upload zip file to ftp
            $(cleanup $transfer) #delete transferring directory
            echo " " >> mytemp
        done
    done

}
$(createZip $BASE_DIR $1 $2 $DEST_DIR)
