## -----------------------------------------------------------------------------
## Linux Scripts.
## Public Key Infrastructure (PKI) management toolkit.
## Sample minimal CA application.
##
## @package ojullien\Shell\app\pki
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

PKI::CA::showHelp() {
    String::notice "Usage: $(basename "$0") ca [command]"
    String::notice "\tSample minimal CA application."
    String::notice "Available Commands:"
    String::notice "\tinit\tInitialise CA repository."
    return 0
}

PKI::CA::initFolders() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: PKI::CA::initFolders <folder path>"
        return 1
    fi

    # Init
    local sPath="$1"
    local -i iReturn=1

    # Do the job "${m_PKI_CA_DIRNAMES["A"]} readonly -A m_PKI_CA_DIRNAMES=( [archive]="archive" [private]="private" [databases]="db" [certificates]="certs" );
    # readonly -A m_PKI_CA_CERTS_DIRNAMES=( [certificate]="crt" [revokelist]="crl" [signingrequest]="csr" );
    String::notice -n "Creating '${sPath}/*' directories: "
    mkdir --parents "${sPath}/{${m_PKI_CA_DIRNAMES[archive]},${m_PKI_CA_DIRNAMES[private]},${m_PKI_CA_DIRNAMES[databases]},${m_PKI_CA_DIRNAMES[certificates]}/{${m_PKI_CA_CERTS_DIRNAMES[certificate]},${m_PKI_CA_CERTS_DIRNAMES[revokelist]},${m_PKI_CA_CERTS_DIRNAMES[signingrequest]}}}"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    String::notice -n "Change '${sPath}/${m_PKI_CA_DIRNAMES[private]}' mode:"
    chmod 700 "${sPath}/${m_PKI_CA_DIRNAMES[private]}"
    iReturn+=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

PKI::CA::createDatabases() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: PKI::CA::createDatabases <CA path> <CA name>"
        return 1
    fi

    # Init
    local sPath="$1" sName="$2"
    local -i iReturn=0

    # Do the job
    String::notice -n "Creating '${sPath}/${sName} databases :"
    cp /dev/null "${sPath}/${m_PKI_CA_DIRNAMES[databases]}/${sName}.db"
    cp /dev/null "${sPath}/${m_PKI_CA_DIRNAMES[databases]}/${sName}.db.attr"
    echo 01 > "${sPath}/${m_PKI_CA_DIRNAMES[databases]}/${sName}.crt.srl"
    echo 01 > "${sPath}/${m_PKI_CA_DIRNAMES[databases]}/${sName}.crl.srl"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

PKI::CA::main() {

    # Parameters
    if (($# < 1)); then
        PKI::CA::showHelp
        return 1
    fi

    # Do the job
    case "$1" in
        init)
            PKI::CA::initFolders "${m_PKI_CA_DIR}"
            PKI::CA::createDatabases "${m_PKI_CA_DIR}" "${m_PKI_CA_NAMES[root]}"
            ;;
        *)
            PKI::CA::showHelp
            ;;
    esac
}
