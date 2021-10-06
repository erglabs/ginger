#!/bin/bash

#TODO broken, needs updating
# value of ${MYDIR} will be inherited from preconfig handler calling it

if [[ -d "${HOME}/.emacs" ]]
then
    _:gt_warn "want to replace initial emacs config in ${HOME}/.emacs ?"
    while true
    do
        read -n 1 -rp "$(_:gclred) [Y]es/[N]o $(_:gcreset)" -p $'\n'
        if [[ ${REPLY} =~ ^[Yy]$ ]]
        then
            cp -r "${MYDIR}/enacs/emacs.conf" "${HOME}/.emacs"
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
fi #inner
mkdir -p ${HOME}/.config/
cp -r "${MYDIR}/emacs/emacs.conf" "${HOME}/.emacs"
