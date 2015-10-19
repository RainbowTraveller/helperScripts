
FTP_DIR="/353605/images/qa/09/00"
TRANSFERRING_DIR="/Users/milind/tarzipplay/09/00/transferring"
FILE="9_0-2015-06-23_01:45:11.tar.gz"
FTPLOG="./ftplog"

upload() {
echo "Inside upload $1 $2 $3" >> mytemp
#echo ${2##*/} >> mytemp
#zip_file=${2##*/}
cur_dir=$(pwd)

HOST="saavnpl.upload.akamai.com"
USER="playlist_img_upload"
PASS="aHf5H3YJkw"

ftp -inv $HOST <<UPLOAD > $FTPLOG
quote USER $USER
quote PASS $PASS
lcd $2
cd $1
binary
put $3
quit
UPLOAD
cd $cur_dir

FTP_SUCCESS_MSG="226 Transfer complete"
if fgrep "$FTP_SUCCESS_MSG" $FTPLOG ;then
   echo "ftp OK"
else
      echo "ftp Error: "$OUT
  fi
exit 0

}

$(upload $FTP_DIR $TRANSFERRING_DIR $FILE) #Upload zip file to ftp
