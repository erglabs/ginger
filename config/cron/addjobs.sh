#!/bin/bash
 MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
 TASKLIST="$(crontab -l)"
 for each in ${MYDIR}/*.sh
 do
    if [[ "$(readlink -f ${0})" != "$(readlink -f ${each})" ]]
    then
        if ! crontab -l 2>/dev/null | grep "$(basename $(readlink -f ${each}))" &> /dev/null
        then
            params=$(grep '#GCPARAM#' ${each} | head -1 | cut -d ' ' -f 2-)
            if [[ "${params}" == '' ]]
            then
                echo 'params inf file are empty, skipping'
                echo "file [${each}]"
            else
                crontab - <<<$(echo "$(crontab -l 2>/dev/null)" ; echo "${params} ${each}")
            fi
        else
            echo "entry in file offends existing config, please resolve confilict manually! [${each}]"
        fi

    fi
done
exit



