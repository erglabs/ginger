#!/bin/bash

#SOURCE="${BASH_SOURCE[0]}"
#while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
#  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
#  SOURCE="$(readlink "$SOURCE")"
#  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
#done
#DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

#echo working with "$(pwd)"
DISPLAY=:0
eval "export $(egrep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME gnome-session)/environ)" &>/dev/null;

log=${HOME}/.timer/info
DIR=${HOME}/.timer
cd ${DIR}
echo ${HOME} >> ${log}
list=($(${HOME}/.bin/fd '.s$'))

#list=($(fd *.time 2>/dev/null))

for each in "${list[@]}";
do
  file=${each}
  echo file >> ${log}

  name="$(echo ${file} | cut -d . -f 1)"
  echo working with echo "${each}" >> ${log}
  MIN=$(cat ${each})
  if [[ "${MIN}" == "0" ]]
  then
    DISPLAY=:0 /usr/bin/notify-send --urgency=normal -t $((1000*5)) "${name} : expired!" -a timer
    rm -rf ${each}
    continue
  fi
  if [[ "$(cat ${each})" == "30" ]]
  then
    DISPLAY=:0 /usr/bin/notify-send --urgency=normal -t $((1000*5)) "${name} : 30 min left" -a timer
  fi
  if [[ "$(cat ${each})" == "5" ]]
  then
    DISPLAY=:0 /usr/bin/notify-send --urgency=normal -t $((1000*5)) "${name} : 5 min left" -a timer
  fi
  echo ${name}:${MIN} >> ${log}
  echo $((${MIN}-1)) > ${file}
done
