#!/bin/bash
# Program:
#     This progarm is using to init trash.sh script.
# History:
#     2018/01/02 rebelsre First release
# Usage method:
#     sh trash_init.sh
# Known BUG:
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

if [ `/bin/rm --version | grep "rm (GNU coreutils)" | wc -l` -eq 1 ] ; then
    mv /bin/rm /bin/rm.old
    cp trash.sh /bin/rm
else
    echo "Your RM command is not a system with your own."
    exit 1
fi
