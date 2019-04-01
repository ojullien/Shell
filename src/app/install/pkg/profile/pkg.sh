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

## -----------------------------------------------------------------------------
## Functions
## -----------------------------------------------------------------------------
Profile::addLines() {

    # Parameters
    if (( $# != 1 )) || [[ -z "$1" ]]; then
        String::error "Usage: Profile::addLines <full filename and path>"
        return 1
    fi

    # Init
    local sFile="$1"
    local -i iReturn=0

    # Do the job
    String::notice "Configuring ${sFile} ..."
    echo "if [ -d \"/opt/oju/Shell/bin\" ] ; then" | tee --append "${sFile}"
    echo '    PATH="$PATH:/opt/oju/Shell/bin"' | tee --append "${sFile}"
    echo "fi" | tee -a "${sFile}"
    String::notice -n "Configure ${sFile}:"
    String::success "OK"

    return ${iReturn}
}

Profile::configureFile() {

    # Parameters
    if (( $# != 3 )) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
        String::error "Usage: Profile::configureFile <user> <home path> <file>"
        return 1
    fi

    # Init
    local sUser="$1" sPathFile="$2/.$3"
    local -i iReturn=1

    # Save current files
    FileSystem::copyFile "${sPathFile}" "${m_INSTALL_PROFILE_DIR_REALPATH}/conf_saved/${m_DATE}_${sUser}_$3"

    # Add lines
    Profile::addLines "${sPathFile}"

    # Changing owner
    String::notice -n "Changing owner:"
    chown "${sUser}":"${sUser}" "${sPathFile}"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

Profile::configure() {

    # Init
    local sUser=""
    local -i iReturn=1

    # Configure .profile for root
    Profile::configureFile "root" "/root" "profile"
    ((iReturn+=$?))

    # Configure .bash_profile for root
    Profile::configureFile "root" "/root" "bash_profile"
    ((iReturn+=$?))

    # Configure files for users
    for sUser in "${m_INSTALL_USERS[@]}"; do
            # Configure .profile
            Profile::configureFile "${sUser}" "/home/${sUser}" "profile"
            ((iReturn+=$?))

            # Configure .bash_profile
            Profile::configureFile "${sUser}" "/home/${sUser}" "bash_profile"
            ((iReturn+=$?))
    done

    return ${iReturn}
}
