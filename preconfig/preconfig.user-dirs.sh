#!/bin/bash


if [[ -f "${MYDIR}/user-dirs.dirs" ]]
then
    _:gt_warn "want to replace user-dis.dirs config in ${HOME}/.config/user-dirs.dirs ?"
    while true
    do
        read -n 1 -rp "$(_:gclred) [Y]es/[N]o $(_:gcreset)" -p $'\n'
        if [[ ${REPLY} =~ ^[Yy]$ ]]
        then
            cp -r "${MYDIR}/user-dirs.dirs" "${HOME}/.config/"
            return 0
            break
        fi
        if [[ ${REPLY} =~ ^[Nn]$ ]]
        then
            cp -rn "${MYDIR}/user-dirs.dirs" "${HOME}/.config/"
            return 0
            break
        fi
        _:gt_error_n "invalid answer, i need : N, n, Y or y"
    done
else
        _:gt_warn "user-dirs.dirs preconfig file is missing! aborting!"
        return 1
fi
