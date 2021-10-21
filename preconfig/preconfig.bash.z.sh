#!/bin/bash


if [[ -f "${MYDIR}/bash.z" ]]
then
    _:gt_warn "want to replace ${HOME}/.bash.z ?"
    while true
    do
        read -n 1 -rp "$(_:gclred) [Y]es/[N]o $(_:gcreset)" -p $'\n'
        if [[ ${REPLY} =~ ^[Yy]$ ]]
        then
            cp -r "${MYDIR}/bash.z" "${HOME}/.bash.z"
            return 0
            break
        fi
        if [[ ${REPLY} =~ ^[Nn]$ ]]
        then
            cp -rn "${MYDIR}/bash.z" "${HOME}/.bash.z/"
            return 0
            break
        fi
        _:gt_error_n "invalid answer, i need : N, n, Y or y"
    done
else
        _:gt_warn "sample bash.z file is missing! aborting!"
        return 1
fi
