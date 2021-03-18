#!/bin/bash
if [[ ! -z ${GDEBUG} ]] ;then set -x ; fi

function countdown()
{
	MINUTE=$(echo $1 | cut -d ":" -f 2)
	HOUR=$(echo $1 | cut -d ":" -f 1)
	TIME=$(((MINUTE*60)+(HOUR*60*60)))
	if [[ ! -z $MINUTE ]] ; then TIME=$((MINUTE*60)) ; fi
	if [[ ! -z $HOUR   ]] ; then TIME=$(((HOUR*60*60)+TIME)) ; fi
	echo $TIME
	nohup sleep $TIME && yad --text 'alarm' 1>/dev/null 2>/dev/null &
}
