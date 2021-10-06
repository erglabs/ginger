#!/bin/bash
if [[ ! -z ${GDBG} ]] ; then
  set -x
fi

echo ' '
echo ' >>> ginger is warming up!'
echo ' >>> versioninfo:'
echo ' >>>   Q2 2021 update'
echo " >>>   $(cat version.nfo)"
WHEREAMI=$(readlink -f $0)
WHEREAMI=$(echo ${WHEREAMI} | awk -F'/' '{for (i=2; i<=(NF-1); i++) printf("/%s", $i)}')

# we want some basic helpers before instalation
source ${WHEREAMI}/core/intro/ginger_farsight.gig
source ${WHEREAMI}/core/intro/ginger_tag.gig
GINGER_INSTALL_DIR=""

function separator()
{
    _:gclred
    echo '##################################################'
    _:gcreset
    return 0
}

function separator_n()
{
    echo ' '
    separator
    echo ' '
    return 0
}

function blankline()
{
    echo ' '
}


function ynquestion()
{
    # $1 query
    # (posix querry, 0=ok!)
    # r=>1 on false
    # r=>0 on true

    _:gt_warn_n "$1"
    _:gt_warn "is it ok to do that?  "

    while true ; do
        # version echoing choice:
        # read -s -n 1 -rep "$(_:gclred) [Y]es/[N]o $(_:gcreset)" -p $'\n'
        read -s -n 1 -rp "$(_:gclred) [Y]es/[N]o $(_:gcreset)" -p $'\n'
        if [[ ${REPLY} =~ ^[Yy]$ ]] ; then
            return 0
            break
        fi
        if [[ ${REPLY} =~ ^[Nn]$ ]] ; then
            return 1
            break
	    fi
        _:gt_error_n "invalid answer, i need : N, n, Y or y"
    done
}


## SetUp installation
separator_n
if ynquestion "I want to install ginger in ${HOME}" ; then
    GINGER_INSTALL_DIR=${HOME}
else
    while true ; do
    	read -r -p "$(_:gt_warn_n 'ok then, enter your own path: (it must exist!)')" GINGER_INSTALL_DIR
	    if [[ -d "${GINGER_INSTALL_DIR}" ]]
            then break
	    else
            _:gt_warn_n 'dir does not exist... try again' ;
	    fi
    done
fi

## Network Test
separator_n
_:gt_notify_n 'autoupdating is not working yet, but when its done it will need network'
_:gt_notify_n 'this is just a test, it will not do anything, besides testing network connectivity'
_:gt_notify_n 'this may be used in future, but we will notify you of that!'
blankline

if ynquestion "I would like to test network connectivity to google DNS... can i? " ; then
    _:gt_notify_n 'trying to connect to network!'
    _:gt_notify_n 'using google dns!'

    if ! ping 8.8.8.8 -c 1 -W 2 1>/dev/null
    then
        _:gt_error_n 'no internet connection detected or google dns are down,'
    else
        _:gt_status_n 'connection successfull!'
    fi
else
    _:gt_status_n 'okay!'
fi

separator_n
_:gt_notify_n "as ginger is installed usually once during system provisioning"
_:gt_notify_n "i would like to use that to download some basic software for you"
_:gt_notify_n "this step is fully optional, and here is a list of stuff you can choose"
_:gt_notify_n '::::::::::::::::::::::::::::::::::::::::::::::'
_:gt_notify_n "-> sublime-text 4 .... (dev)(x86-64) <- needs licence"
_:gt_notify_n "-> firefox beta   .... (en_US)(x64)"
_:gt_notify_n '::::::::::::::::::::::::::::::::::::::::::::::'

if [[ ! -d "${HOME}/.pack" ]] ; then mkdir "${HOME}/.pack" ; fi
if [[ ! -d "${HOME}/.bin" ]] ; then mkdir "${HOME}/.bin" ; fi
if [[ ! -d "${HOME}/.archive" ]] ; then mkdir "${HOME}/.archive" ; fi

blankline
unset _additional_soft
if ynquestion "I want to install mentioned additional software (goto choice menu)" ; then
  _additional_soft=1
fi

    if [[ ! -z ${_additional_soft} ]] &&  ynquestion '>>: sublime text 4 (dev)' ; then
  	  wget --no-clobber -q --show-progress -P "${HOME}/.archive/" $(curl -s https://www.sublimetext.com/dev  | grep -oP '(?<=")(https://download\.sublimetext\.com/sublime_text_build_.*_x64\.tar\.xz)(?=")')
  	  # wget -q --show-progress -P "${HOME}/.archive/" $(curl -s https://www.sublimetext.com/dev  | grep -oP '(?<=")(https://download\.sublimetext\.com/sublime-text-.*\.tar\.xz)(?=")' | grep aarch64)
      archive_file=$(ls -l "${HOME}/.archive" | grep -oP "sublime_text_build_.+\_x64.tar.xz" | tail -1)
	  tar -C "${HOME}/.pack" -axvf "${HOME}/.archive/${archive_file}"
	  cp "${WHEREAMI}/preconfig/executors/subl" "${HOME}/.bin/"
	  blankline
    fi
    if [[ ! -z ${_additional_soft} ]] && ynquestion '>>: firefox (en_US)(x64)' ; then
      ff_version=$(curl -q https://download-installer.cdn.mozilla.net/pub/firefox/releases/ 2>/dev/null | grep -oP "[0-9]{2,3}\.[0-9]{1,3}[b]?[0-9]?" | tail -1)
	  wget -nc -q --show-progress -P "${HOME}/.archive/" https://download-installer.cdn.mozilla.net/pub/firefox/releases/${ff_version}/linux-x86_64/en-US/firefox-${ff_version}.tar.bz2
      archive_file=$(ls -l "${HOME}/.archive" | grep -oP "firefox.+\.tar.bz2" | tail -1)
	  tar -C "${HOME}/.pack" -axvf "${HOME}/.archive/${archive_file}"
	  # rm -rf "${HOME}/.pack/firefox"
	  cp "${WHEREAMI}/preconfig/executors/firefox" "${HOME}/.bin/"
	  blankline
    fi
unset _additional_soft

## actual instalation start here
## prepare dirctories and copy content
separator_n
    _:gt_notify_n '... working on ginger core!'
    mkdir   -p  ${GINGER_INSTALL_DIR}/.ginger

    # we are wiping only scripts, config will persist!
    rm      -rf ${GINGER_INSTALL_DIR}/.ginger/core
    rm      -rf ${GINGER_INSTALL_DIR}/.ginger/cron
    rm      -rf ${GINGER_INSTALL_DIR}/.ginger/systemd

    cp -r ${WHEREAMI}/core                   ${GINGER_INSTALL_DIR}/.ginger/ 2>/dev/null
    cp -r ${WHEREAMI}/cron                   ${GINGER_INSTALL_DIR}/.ginger/ 2>/dev/null
    cp -r ${WHEREAMI}/systemd                ${GINGER_INSTALL_DIR}/.ginger/ 2>/dev/null
    cp    ${WHEREAMI}/init 	                 ${GINGER_INSTALL_DIR}/.ginger/init
#    cp    ${WHEREAMI}/core/databases/gdb.src ${GINGER_INSTALL_DIR}/.ginger/core/databases/.gdb.src # todo fixit
    _:gt_notify_n "..."

    # lets see if bashrc is available and fix it if its not there
    if [[ ! -f "${HOME}/.bashrc" ]]; then
        _:gt_warn_n "copied default bashrc"
        cp "${WHEREAMI}/preconfig/bashrc" "${HOME}/.bashrc"
    fi

    # lets fix and replace the bashrc info
    if [[ -f "${HOME}/.bashrc" ]]; then
        sed -i '1d'                                                   ${HOME}/.bashrc
        sed -i '/.*#GCA#.*/d'                                         ${HOME}/.bashrc
        sed -i "1i#!/bin/bash"                                        ${HOME}/.bashrc
        sed -i '2icase $- in *i*) ;; *) return;; esac #GCA#'          ${HOME}/.bashrc
        sed -i "3iGINGER_HOME=${GINGER_INSTALL_DIR} #GCA#"            ${HOME}/.bashrc
        sed -i "4isource ${GINGER_INSTALL_DIR}/.ginger/init #GCA#"    ${HOME}/.bashrc
        _:gt_notify_n "Ginger Core ready!"
    else
        _:gt_error_n "FAILED TO INSTALL! .bashrc not present in default directory!"
        [[ -d ${GINGER_INSTALL_DIR}/.ginger ]] && rm -ir ${GINGER_INSTALL_DIR}/.ginger
        _:gt_error_n "scrapping changes!"
    fi

separator_n
if ynquestion "[FEATURE INSTALL] I would like to start user configurations provisioning" ; then
    source ${WHEREAMI}/preconfig/handler.gig
fi
## todo if exist update
## install fuzzy if requested
## todo: be verbose if it exist already

separator_n
if ynquestion "[FEATURE INSTALL] I would like to install fuzzy tool" ; then
    if [[ ! -d ${HOME}/.fuzzy ]] ; then #todo check if git exist
	mkdir ${HOME}/.fuzzy
	out=$(pwd)
	cd ${HOME}/.fuzzy
	git clone https://github.com/junegunn/fzf.git .
	_:gclbrown
	./install --all
	_:gcreset
	cd "${out}"
    fi
fi

separator_n
if ynquestion "[FEATURE INSTALL] I would like to install userspace rust toolchain" ; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi


if false ; then # todo: if git not exist provide it from ginger
https://github.com/junegunn/fzf.git
    if [[ ! -f ${HOME}/.fzf ]]; then
	    _:gclbrown
	    ${WHEREAMI}/projects/fzf/install
	    _:gcreset
    else
	    _:gt_notify_n "Fuzzy is already installed!, skipping"
	    #maybe update procedure here?
    fi
fi


separator_n
_:gt_notify_n "ok, we are finished here, it should work on next console spawn!"
_:gt_notify_n "thanks for using my stuff!"
_:gt_notify_n "best regards"
_:gt_notify_n "esavier  ...| ergLabs team"
_:gt_notify_n "kvexel  ....| ergLabs team"
_:gt_notify_n "qc  ........| ergLabs team"
_:gt_notify_n "usego_  ....| ergLabs team"
_:gt_notify_n "daizy  .....| contributor "

