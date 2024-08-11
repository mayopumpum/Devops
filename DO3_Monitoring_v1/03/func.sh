function exit_prog {
    exit 1
}

function check_params {
    
if [ $# -ne 4 ]
then
    echo "Params must 4. Try again"
    exit_prog
fi

for param in $@
do
    if [[ ($param -gt 6) || ($param -lt 0) ]]
    then
        echo "All parameters must be digits from 0 to 6. Try again"
        exit_prog
    fi    
done

for param in $@
do
    if [[ ($1 -eq $2) || ($3 -eq $4) ]]
    then
        echo "Colors math. Try again"
        exit_prog
    fi    
done

}


function get_info {
    # Colors: 1 - white, 2 - red, 3 - green, 4 - blue, 5 – purple, 6 - black
    back_colors=("\e[47m" "\e[41m" "\e[42m" "\e[44m" "\e[45m" "\e[40m")
    font_colors=("\e[37m" "\e[31m" "\e[32m" "\e[34m" "\e[35m" "\e[30m")

    LC='\033[0m'
    LB=${back_colors[$1 - 1]}
    LF=${font_colors[$2 - 1]}
    RB=${back_colors[$3 - 1]}
    RF=${font_colors[$4 - 1]}

    echo -e ${LB}${LF}HOSTNAME${LC} = ${RB}${RF}$HOSTNAME${LC}

    echo -e ${LB}${LF}"TIMEZONE${LC} = ${RB}${RF}"$(cat /etc/timezone) "UTC" $(date +"%Z")${LC}

    echo -e ${LB}${LF}USER${LC} = ${RB}${RF}$USER${LC}

    echo -e ${LB}${LF}OS${LC} = ${RB}${RF}`cat /etc/issue | cut -d' ' -f1,2,3`${LC}

    echo -e ${LB}${LF}DATE${LC} = ${RB}${RF}`date +'%d %b %Y %T'`${LC}

    echo -e ${LB}${LF}UPTIME${LC} = ${RB}${RF}`uptime -p`${LC}

    echo -e ${LB}${LF}UPTIME_SEC${LC} = ${RB}${RF}`awk '{print $1}' /proc/uptime`${LC}

    echo -e ${LB}${LF}IP${LC} = ${RB}${RF}`ip a show dev enp0s3 | grep "global enp0s3" | awk '{print $2}' | cut -d'/' -f1`${LC}

    echo -e ${LB}${LF}MASK${LC} = ${RB}${RF}`ifconfig enp0s3 | grep netmask | awk '{print $4}'`${LC}

    echo -e ${LB}${LF}GATEWAY${LC} = ${RB}${RF}`ip r | grep default | awk '{print $3}'`${LC}

    echo -e ${LB}${LF}RAM_TOTAL${LC} = ${RB}${RF}`free --mega | awk 'NR == 2{printf "%.3f GB\n", $2 / 1024}'`${LC}

    echo -e ${LB}${LF}RAM_USED${LC} = ${RB}${RF}`free --mega | awk 'NR == 2{printf "%.3f GB\n", $3 / 1024}'`${LC}

    echo -e ${LB}${LF}RAM_FREE${LC} = ${RB}${RF}`free --mega | awk 'NR == 2{printf "%.3f GB\n", $4 / 1024}'`${LC}

    echo -e ${LB}${LF}SPACE_ROOT${LC} = ${RB}${RF}`df / | awk 'NR == 2{printf "%.2f MB\n", $2 / 1024}'`${LC}

    echo -e ${LB}${LF}SPACE_ROOT_USED${LC} = ${RB}${RF}`df / | awk 'NR == 2{printf "%.2f MB\n", $3 / 1024}'`${LC}

    echo -e ${LB}${LF}SPACE_ROOT_FREE${LC} = ${RB}${RF}`df / | awk 'NR == 2{printf "%.2f MB\n", $4 / 1024}'`${LC}
}