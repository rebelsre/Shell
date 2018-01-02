#!/bin/bash
# Program:
#     This progarm is using to change rm command.
# History:
#     2018/01/02 rebelsre First release
# Usage method:
#     mv /bin/rm /bin/rm.old
#     cp /path/to/trash.sh /bin/rm
# Known BUG:
#     The recycle function can cause a two - fold cycle and redirects the error output to /dev/null
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

##### variable #####
user=`whoami`
timestamp=`date +%Y%m%d%H%M`
recycle_bin=/data/trash
parameter=`echo $@ | sed -e 's/-rf//g' -e 's#/ \+# #g' -e 's#/$##g'`
disk_availability=`df -m | grep -w / | awk '{print $4}'`
file_size=`du -sm ${parameter} | awk '{ sum += $1 }; END { print sum }'`	#This step may be slow.
dir_name=`ls -d ${parameter} | xargs -I {} dirname {} | xargs`
base_name=`ls -d ${parameter} | xargs -I {} basename {} | xargs`

##### function #####
recycle() {
    for f in ${base_name}
        do
            for d in ${dir_name}
                do
                    mv $d/$f ${recycle_bin}/$f-${user}-${timestamp}
                done 2>/dev/null
        done
}

disk() {
    if [[ ${file_size} -gt ${disk_availability} ]] ; then
        read -t 30 -p "Please confirm that you want to delete this file:(yes/no) " judge
        if [ "${judge}" == "yes" ] ; then
            /bin/rm.old -rf ${parameter}
        else
            exit 0
        fi
    fi
}

##### action #####
disk
recycle
