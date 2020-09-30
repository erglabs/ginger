#!/bin/bash

#echo working with "$(pwd)"
log=${HOME}/.timer/info
DIR=${HOME}/.timer
cd ${DIR}
#echo ${HOME} >> ${log}
list=($(${HOME}/.bin/fd '.s$'))
#list=($(fd *.time 2>/dev/null))

for each in "${list[@]}";
do
  file=${each}
  name="$(echo ${file} | cut -d . -f 1)"
#  echo working with echo "${each}"
  MIN=$(cat ${each})
  echo -n "|${name}:${MIN}"
  #echo $((${MIN}-1))
done
