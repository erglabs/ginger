#!/bin/bash

# value of ${MYDIR} will be inherited from preconfig handler calling it
if [[ ! -d "${HOME}/.provision/" ]]
then
    mkdir -p "${HOME}/.provision/"
fi

if [[ -d "${HOME}/.provision/logrotate" ]]
then
    _:gt_warn "want to replace whole nano config in ${HOME}/.provision/logrotate ?"
    _:gt_warn "if you choose not to replace, i will only copy files that dont exist!"
    while true
    do
        read -n 1 -rp "$(_:gclred) [Y]es/[N]o $(_:gcreset)" -p $'\n'
        if [[ ${REPLY} =~ ^[Yy]$ ]]
        then
            cp -r "${MYDIR}/logrotate" "${HOME}/.provision/logrotate"
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
