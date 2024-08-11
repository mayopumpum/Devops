function get_info {
    echo HOSTNAME = $HOSTNAME

    echo "TIMEZONE = "$(cat /etc/timezone) "UTC" $(date +"%Z")

    echo USER = $USER

    echo OS = `cat /etc/issue | cut -d' ' -f1,2,3`

    echo DATE = `date +'%d %b %Y %T'`

    echo UPTIME = `uptime -p`

    echo UPTIME_SEC = `awk '{print $1}' /proc/uptime`

    echo IP = `ip a show dev enp0s3 | grep "global enp0s3" | awk '{print $2}' | cut -d'/' -f1`

    echo MASK = `ifconfig enp0s3 | grep netmask | awk '{print $4}'`

    echo GATEWAY = `ip r | grep default | awk '{print $3}'`

    echo RAM_TOTAL = `free --mega | awk 'NR == 2{printf "%.3f GB\n", $2 / 1024}'`

    echo RAM_USED = `free --mega | awk 'NR == 2{printf "%.3f GB\n", $3 / 1024}'`

    echo RAM_FREE = `free --mega | awk 'NR == 2{printf "%.3f GB\n", $4 / 1024}'`

    echo SPACE_ROOT = `df / | awk 'NR == 2{printf "%.2f MB\n", $2 / 1024}'`

    echo SPACE_ROOT_USED = `df / | awk 'NR == 2{printf "%.2f MB\n", $3 / 1024}'`

    echo SPACE_ROOT_FREE = `df / | awk 'NR == 2{printf "%.2f MB\n", $4 / 1024}'`
}