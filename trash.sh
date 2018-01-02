#!/bin/bash
# Program:
#     This progarm is using to change rm command.
# History:
#     2018/01/02 rebelsre First release
# Usage method:
#     mv /bin/rm /bin/rm.old
#     cp /path/to/trash.sh /bin/rm
# Known BUG:
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

##### variable #####
user=`whoami`
timestamp=`date +%Y%m%d%H%M`
recycle_bin=/data/trash
parameter=`echo $@ | sed -e 's#-[drfiIv]\+\s*##g' -e 's#/ \+# #g' -e 's#/$##g' | grep -w -v '/|/etc|/boot/|opt|/var/|/usr'`
disk_availability=`df -m /data | grep "/" | awk '{print $4}'`
file_size=`du -sm "${parameter}" | awk '{ sum += $1 }; END { print sum }'`  #This step may be slow.

##### function #####
recycle() {
    for file in "${parameter}"
        do
            dir_name=`dirname "${file}"`
            base_name=`basename "${file}"`
            mv "${file}" ${recycle_bin}/"${base_name}"-${user}-${timestamp}.${RANDOM}
        if [ $? -eq 0 ] ; then 
            echo "${timestamp}, rm_file: ${file}, file_initial_path: $(pwd)." | tee -a ${recycle_bin}/.history
        else
            echo "Error,please check the file you want to delete!"
        fi
        done
}

disk() {
    if [[ ${file_size} -gt ${disk_availability} ]] ; then
        read -t 30 -p "Please confirm that you want to delete this file:(yes/no) " judge
        if [ "${judge}" == "yes" ] ; then
            /bin/rm.old -rf "${parameter}"
        else
            exit 0
        fi
    fi
}

build() {
    if [ ! -d ${recycle_bin} ] ; then
        mkdir -p ${recycle_bin}
        chmod -R 1777 ${recycle_bin}
        touch ${recycle_bin}/.history
        chmod -R 1777 ${recycle_bin}/.history
    fi
}

trash_init() {
    if [ `/bin/rm.old --version | grep "rm (GNU coreutils)" | wc -l` -eq 0 ] ; then
        echo "Your RM command is not a system with your own."
        exit 1
    fi
}

##### action #####
trash_init
build
disk
recycle
