#!/bin/bash

echo '[GINGER][PCFG] Preconfig: Nano : i need aspell as a spelling checker, its optional, but if you dont mind, please install it'
echo '[GINGER][PCFG] Preconfig: Nano : just type -> apt install aspell-(language of yor choosing)'

#TODO broken, needs updating
# value of ${MYDIR} will be inherited from preconfig handler calling it

if [[ -d "${HOME}/.config/nano" ]]
then
    _:gt_warn "want to replace whole nano config in ${HOME}/.config/nano ?"
    while true
    do
        read -n 1 -rp "$(_:gclred) [Y]es/[N]o $(_:gcreset)" -p $'\n'
        if [[ ${REPLY} =~ ^[Yy]$ ]]
        then
            cp -r "${MYDIR}/nano" "${HOME}/.config/nano"
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
cp -r "${MYDIR}/nano" "${HOME}/.config/nano"
