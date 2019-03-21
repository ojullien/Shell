## -----------------------------------------------------------------------------
## bashrc & bash_alias.
## bashrc & bash_alias install package functions.
##
## @package ojullien\Shell\app\install\pkg\bashrc
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Constants
## -----------------------------------------------------------------------------
readonly m_INSTALL_BASHRC_DIR_REALPATH="${m_INSTALL_DIR_REALPATH}/pkg/bashrc"
readonly m_INSTALL_BASHRC_FILENAME="bashrc"
readonly m_INSTALL_BASHALIASES_FILENAME="bash_aliases"

## -----------------------------------------------------------------------------
## Functions
## -----------------------------------------------------------------------------
BashRC::configure() {

    # Init
    local sUser="" sCurrent=""
    local -i iReturn=1

    # Save current root conf
    sCurrent="/root/.${m_INSTALL_BASHRC_FILENAME}"
    FileSystem::moveFile "${sCurrent}" "${m_INSTALL_BASHRC_DIR_REALPATH}/conf_saved/${m_DATE}_root_${m_INSTALL_BASHRC_FILENAME}"

    # Install new root conf
    FileSystem::copyFile "${m_INSTALL_BASHRC_DIR_REALPATH}/conf_new/root" "${sCurrent}"
    iReturn=$?
    ((0!=iReturn)) && return ${iReturn}

    # Save current users conf and install new ones
    for sUser in "${m_INSTALL_USERS[@]}"; do
        sCurrent="/home/${sUser}/.${m_INSTALL_BASHRC_FILENAME}"
        FileSystem::moveFile "${sCurrent}" "${m_INSTALL_BASHRC_DIR_REALPATH}/conf_saved/${m_DATE}_${sUser}_${m_INSTALL_BASHRC_FILENAME}"
        FileSystem::copyFile "${m_INSTALL_BASHRC_DIR_REALPATH}/conf_new/user" "${sCurrent}"
        iReturn=$?
        ((0!=iReturn)) && return ${iReturn}
        String::notice -n "Changing owner:"
        chown "${sUser}":"${sUser}" "${sCurrent}"
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
        ((0!=iReturn)) && return ${iReturn}
    done

    return ${iReturn}
}

BashRC::configureUserAliases() {

    # Parameters
    if (( $# != 2 )) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: BashRC::configureUserAliases <user> <home path>"
        return 1
    fi

    # Init
    local sUser="$1" sCurrent="$2/.${m_INSTALL_BASHALIASES_FILENAME}"
    local -i iReturn=1

    # Save current file
    FileSystem::moveFile "${sCurrent}" "${m_INSTALL_BASHRC_DIR_REALPATH}/conf_saved/${m_DATE}_${sUser}_${m_INSTALL_BASHALIASES_FILENAME}"

    # Do the job
    String::notice -n "Configure ${sCurrent}:"
    echo "alias rm=\"rm -i\"" | tee "${sCurrent}"
    echo "alias cp=\"cp -i\"" | tee -a "${sCurrent}"
    echo "alias mv=\"mv -i\"" | tee -a "${sCurrent}"
    String::success "OK"

    String::notice -n "Changing owner:"
    chown "${sUser}":"${sUser}" "${sCurrent}"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

BashRC::configureAliases() {

    # Init
    local sUser=""
    local -i iReturn=1

    # Configure bash_aliases for root
    BashRC::configureUserAliases "root" "/root"
    ((0!=iReturn)) && return ${iReturn}

    # Configure bash_aliases for users
    for sUser in "${m_INSTALL_USERS[@]}"; do
        BashRC::configureUserAliases "${sUser}" "/home/${sUser}"
        ((0!=iReturn)) && return ${iReturn}
    done

    return ${iReturn}
}
