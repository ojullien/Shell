## -----------------------------------------------------------------------------
## Linux Scripts.
## Public Key Infrastructure (PKI) management toolkit.
## PKI common wrapper functions.
##
## @package ojullien\Shell\app\pki
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

PKI::showHelp() {
    String::notice "Usage: $(basename "$0") [options] <command>"
    String::notice "\tPKI toolkit"
    Option::showHelp
    String::notice "Available Commands:"
    String::notice "\troot\tRoot CA level application."
    String::notice "\tsigning\tIntermediate Signing CA level application."
    String::notice "\temail\tUser certificate level application."
    String::notice "\tesoft\tUser certificate level application."
    String::notice "\ttls\tUser certificate level application."
    String::notice "Available CA name:"
    for KEY in "${!m_PKI_CA_NAMES[@]}"; do
        String::notice "\t[$KEY]=\"${m_PKI_CA_NAMES[$KEY]}\""
    done
    return 0
}

## -----------------------------------------------------------------------------
## Remove the content of a CA repository.
## -----------------------------------------------------------------------------
PKI::remove() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: PKI::reset <CA path>"
        return 1
    fi

    # Do the job
    FileSystem::cleanDirectory "$1"

    return $?
}

## -----------------------------------------------------------------------------
## Create a CA repository.
## -----------------------------------------------------------------------------
PKI::createRepository() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: PKI::createRepository <CA path> <CA name>"
        return 1
    fi

    # Init
    local sPath="$1" sName="$2"
    local -i iReturn=1

    # Do the job
    String::notice -n "Create '${sName}' repository: "
        mkdir --parents "${sPath}"/{"${m_PKI_CA_DIRNAMES[privatekeys]}","${m_PKI_CA_DIRNAMES[databases]}","${m_PKI_CA_DIRNAMES[signedcertificates]}","${m_PKI_CA_DIRNAMES[revokelist]}","${m_PKI_CA_DIRNAMES[certificatesigningrequests]}"}\
        && chmod 700 "${sPath}/${m_PKI_CA_DIRNAMES[privatekeys]}"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Create CA database files.
## The files must exist before the openssl ca command can be used.
## -----------------------------------------------------------------------------
PKI::createDatabases() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: PKI::createDatabases <CA path> <CA name>"
        return 1
    fi

    # Init
    local sPath="$1" sName="$2"
    local -i iReturn=1

    # Do the job
    String::notice -n "Create '${sName}' databases:"
    touch "${sPath}/${m_PKI_CA_DIRNAMES[databases]}/${sName}.index${m_SSL_FILE_EXTENTIONS[index]}" "${sPath}/${m_PKI_CA_DIRNAMES[databases]}/${sName}.index${m_SSL_FILE_EXTENTIONS[index]}.attr"
    iReturn=$?
    echo 00 >  "${sPath}/${m_PKI_CA_DIRNAMES[databases]}/${sName}.crlnum"
    iReturn+=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}
