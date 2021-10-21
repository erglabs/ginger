#!/bin/bash


if [[ -f "${MYDIR}/bashrc" ]]
then
    _:gt_warn "want to replace whole ${HOME}/.bashrc ?"
    while true
    do
        read -n 1 -rp "$(_:gclred) [Y]es/[N]o $(_:gcreset)" -p $'\n'
        if [[ ${REPLY} =~ ^[Yy]$ ]]
        then
            cp -r "${MYDIR}/bashrc" "${HOME}/.bashrc"
            return 0
            break
        fi
        if [[ ${REPLY} =~ ^[Nn]$ ]]
        then
            cp -rn "${MYDIR}/bashrc" "${HOME}/.bashrc/"
            return 0
            break
        fi
        _:gt_error_n "invalid answer, i need : N, n, Y or y"
    done
else
        _:gt_warn "sample bashrc file is missing! aborting!"
        return 1
fi
