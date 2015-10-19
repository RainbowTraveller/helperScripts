FTP_SUCCESS=false
host_dir="/Users/milind/mainrootdir/transferring"
failed() {
    if [ "$FTP_SUCCESS" = false  ]; then
        echo $1 >> mytemp
        main_dir="${1%/*}"
        echo "$main_dir" >> mytemp
        failed_dir="$main_dir/failed"
        echo "$failed_dir" >> mytemp
        mkdir "$failed_dir"
        mv $1/*gz $failed_dir
    fi
}
$(failed $host_dir)
