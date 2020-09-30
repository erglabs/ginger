#!/bin/bash

# value of ${MYDIR} will be inherited from preconfig handler calling it
if [[ ! -d "${HOME}/.provision/" ]]
then
    mkdir -p "${HOME}/.provision/"
fi

if [[ -d "${HOME}/.provision/cron" ]]
then
    _:gt_warn "want to replace whole nano config in ${HOME}/.provision/cron ?"
    _:gt_warn "if you choose not to replace, i will only copy files that dont exist!"
    while true
    do
        read -n 1 -rp "$(_:gclred) [Y]es/[N]o $(_:gcreset)" -p $'\n'
        if [[ ${REPLY} =~ ^[Yy]$ ]]
        then
            cp -r "${MYDIR}/cron" "${HOME}/.provision/cron"
            break
        fi
        if [[ ${REPLY} =~ ^[Nn]$ ]]
        then
            return 0
            break
        fi
        _:gt_error_n "invalid answer, i need : N, n, Y or y"
    done
    return 0
fi
mkdir -p ${HOME}/.config/
cp -r "${MYDIR}/nano" "${HOME}/.provision/"
return 0

if [[ -f /etc/cron.deny ]]
then
    if grep $(whoami) /etc/cron.deny >> /dev/null
    then
        _:gt_error " user blacklisted in crontab.deny, aborting without jobs instalation "
        return 22
    fi
    if grep $(whoami) /etc/cron.deny >> /dev/null
    then
        _:gt_error " user nor whitelisted in crontab.allow, aborting without jobs instalation "
        return 23
    fi
else
    "${HOME}/.provision/cron/addjobs.sh"
fi
