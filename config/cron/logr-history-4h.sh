!/bin/bash
#GCPARAM# 0 */4 * * *

if [[ $(id -u) -ne 0 ]]
then
	echo '[ERROR] script started by non-root'
fi

if diff --brief ~/.archive/bashhistory/last ~/.bash_history
then
    tar -Jxcv ~/.achive/bashhistory/$(date '+%Y%m%d_%H%M%S').$(whoami).bashhistory.xz -f ~/.bash_history
    cp ~/.bash_history ~/.archive/bashhistory/last
fi
