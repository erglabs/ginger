!/bin/bash
#GCPARAM# 5 * * * *

if [[ $(id -u) -ne 0 ]]
then
	echo '[ERROR] script started by non-root'
fi

updatedb
