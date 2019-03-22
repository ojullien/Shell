## -----------------------------------------------------------------------------
## profile.
## .profile install package functions.
##
## @package ojullien\Shell\app\install\pkg\profile
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Constants
## -----------------------------------------------------------------------------
readonly m_INSTALL_PROFILE_DIR_REALPATH="${m_INSTALL_DIR_REALPATH}/pkg/profile"
readonly m_INSTALL_PROFILE_FILENAME="profile"

## -----------------------------------------------------------------------------
## Functions
## -----------------------------------------------------------------------------
Profile::configureUser() {

    # Parameters
    if (( $# != 2 )) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: Profile::configureUser <user> <home path>"
        return 1
    fi

    # Init
    local sUser="$1" sCurrent="$2/.${m_INSTALL_PROFILE_FILENAME}"
    local -i iReturn=1

    # Save current file
    FileSystem::copyFile "${sCurrent}" "${m_INSTALL_PROFILE_DIR_REALPATH}/conf_saved/${m_DATE}_${sUser}_${m_INSTALL_PROFILE_FILENAME}"

    # Do the job
    String::notice "Configuring ${sCurrent} ..."
    echo "if [ -d \"/opt/oju/Shell/bin\" ] ; then" | tee -a "${sCurrent}"
    echo "    PATH=\"$PATH:/opt/oju/Shell/bin\"" | tee -a "${sCurrent}"
    echo "fi" | tee -a "${sCurrent}"
    String::notice -n "Configure ${sCurrent}:"
    String::success "OK"

    String::notice -n "Changing owner:"
    chown "${sUser}":"${sUser}" "${sCurrent}"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

Profile::configure() {

    # Init
    local sUser=""
    local -i iReturn=1

    # Configure bash_aliases for root
    Profile::configureUser "root" "/root"
    iReturn=$?
    ((0!=iReturn)) && return ${iReturn}

    # Configure bash_aliases for users
    for sUser in "${m_INSTALL_USERS[@]}"; do
        Profile::configureUser "${sUser}" "/home/${sUser}"
        iReturn=$?
        ((0!=iReturn)) && return ${iReturn}
    done

    return ${iReturn}
}
