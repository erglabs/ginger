#!/bin/bash


if [[ ! -d "${HOME}/.config/i3" ]]
then
    mkdir -p "${HOME}/.config/i3"
fi

if [[ -d "${MYDIR}/i3" ]]
then
    _:gt_warn "want to replace whole nano config in ${HOME}/.config/i3 ?"
    while true
    do
        read -n 1 -rp "$(_:gclred) [Y]es/[N]o $(_:gcreset)" -p $'\n'
        if [[ ${REPLY} =~ ^[Yy]$ ]]
        then
            cp -r "${MYDIR}/i3" "${HOME}/.config/"
            return 0
            break
        fi
        if [[ ${REPLY} =~ ^[Nn]$ ]]
        then
            cp -rn "${MYDIR}/i3" "${HOME}/.config/"
            return 0
            break
        fi
        _:gt_error_n "invalid answer, i need : N, n, Y or y"
    done
else
        _:gt_warn "i3 preconfig dir is missing! aborting!"
        return 1
fi