##!/bin/bash
#
## -----------------------------------------------------------------------------
## Linux Scripts.
## 1. Launch the ssh-agent.
## 2. Add your github key to the ssh agent.
## 3. Add completion.
## 4. Change the prompt to see repository status.
##
## Install
##    1. Add the following line to your .bashrc:
##        source ~/Shell/src/enableGit.sh
##
## The script can be executed as standalone. You must uncomment the first line
## and the last lines of the scripts
##
## @category Linux Scripts
## @package git
## @version 20180822
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Constants
## -----------------------------------------------------------------------------

# Directory holds scripts
declare m_DIR_SCRIPT="$(pwd)"
declare ENV_SSH="${HOME}/.ssh/agent.env"
declare KEY_SSH="${HOME}/.ssh/id_rsa_github"

## -----------------------------------------------------------------------------
## Functions
## -----------------------------------------------------------------------------

String::error() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

SSH::loadSSHAgentEnv() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: SSH::loadSSHAgentEnv <ssh environment file path>"
        exit 1
    fi

    # Init
    local sPath="$1"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sPath}" ]]; then
        source "${sPath}" >| /dev/null ;
        iReturn=$?
    fi

    return ${iReturn}
}

SSH::startSSHAgent() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: SSH::startSSHAgent <ssh environment file path>"
        exit 1
    fi

    # Init
    local sPath="$1"
    local -i iReturn=1

    # Do the job in a subshell
    (umask 077; ssh-agent >| "${sPath}")
    iReturn=$?
    source "${sPath}" >| /dev/null ;

    return ${iReturn}
}

SSH::addKeyToSSHAgent() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: SSH::addKeyToSSHAgent <ssh environment file path> <key file>"
        exit 1
    fi

    # Init
    local sSSHEnv="$1" sKeyFile="$2"
    local -i iReturn=1 iRunState=2

    # Do the job

    # iRunState: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
    iRunState=$(ssh-add -l >| /dev/null 2>&1; echo $?)

    if [[ ! "$SSH_AUTH_SOCK" ]] || (( 2==iRunState )); then
        SSH::startSSHAgent "${sSSHEnv}"
        ssh-add "${sKeyFile}"
        iReturn=$?
    elif [ "$SSH_AUTH_SOCK" ] && (( 1==iRunState )); then
        ssh-add "${sKeyFile}"
        iReturn=$?
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Main
## -----------------------------------------------------------------------------

SSH::loadSSHAgentEnv "${ENV_SSH}"
SSH::addKeyToSSHAgent "${ENV_SSH}" "${KEY_SSH}"
unset ENV_SSH KEY_SSH

# Add completion
source "${m_DIR_SCRIPT}/app/enablegit/inc/git-completion.sh"

# See repository status in the prompt.
source "${m_DIR_SCRIPT}/app/enablegit/inc/git-prompt.sh"

export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

# If this script is executed as standalone (not in your .bashrc), uncomment the lines below
#echo "Please execute the lines below in your prompt"
#echo . ${m_DIR_SCRIPT}/app/enablegit/inc/git-completion.sh
#echo . ${m_DIR_SCRIPT}/app/enablegit/inc/git-prompt.sh
#echo export GIT_PS1_SHOWDIRTYSTATE=1
#echo export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

unset m_DIR_SCRIPT
