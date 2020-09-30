#!/bin/bash


if [[ ! -d "${HOME}/.config/rofi" ]]
then
    mkdir -p "${HOME}/.config/rofi"
fi

if [[ -d "${MYDIR}/rofi" ]]
then
    _:gt_warn "want to replace whole nano config in ${HOME}/.config/rofi ?"
    while true
    do
        read -n 1 -rp "$(_:gclred) [Y]es/[N]o $(_:gcreset)" -p $'\n'
        if [[ ${REPLY} =~ ^[Yy]$ ]]
        then
            cp -r "${MYDIR}/rofi" "${HOME}/.config/"
            return 0
            break
        fi
        if [[ ${REPLY} =~ ^[Nn]$ ]]
        then
            cp -rn "${MYDIR}/rofi" "${HOME}/.config/"
            return 0
            break
        fi
        _:gt_error_n "invalid answer, i need : N, n, Y or y"
    done
else
        _:gt_warn "rofi preconfig dir is missing! aborting!"
        return 1
fi