#!/bin/bash
# ЦПУ, оперативная память, жесткий диск (объем)
function checker {
    cpu=`top -b | head -3 | tail +3 | awk '{print $2}'`
    cpu=${cpu%,*}
    mem_used=`free -b | awk 'NR==2{print $4}'`
    hdd_avail=`df -k --output=avail / | tail -n +2`

  # Print the usage
    echo "# TYPE my_cpu_usage gauge"
    echo my_cpu_usage ${cpu}
    echo "# TYPE my_mem_used gauge"
    echo my_mem_used ${mem_used}
    echo "# TYPE my_disk_available gauge"
    echo my_disk_available ${hdd_avail}
}

while : ; do
    checker > report.html
    sleep 5
done