## -----------------------------------------------------------------------------
## Linux Scripts.
## Public Key Infrastructure (PKI) management toolkit.
## Root CA level application. We use the root CA to issue subordinate signing CAs.
##
## @package ojullien\Shell\app\pki
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

PKI::RootLevel::showHelp() {
    String::notice "Usage: $(basename "$0") rootlevel [command]"
    String::notice "\tRoot CA level application. We use the root CA to issue subordinate signing CAs."
    String::notice "Available Commands:"
    String::notice "\thelp\tShow this help."
    String::notice "\tinit\tInitialise the PKI repository."
    String::notice "\treset\tRemove all PKI level repositories. Root CA, subordinate signing CAs and all issued certificates."
    return 0
}

## -----------------------------------------------------------------------------
## Create the Root Certificate
## -----------------------------------------------------------------------------

PKI::RootLevel::createCACertificateSigningRequest() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: PKI::Simple::createCACertificateSigningRequest <CA path> <CA name>"
        return 1
    fi

    # Init
    local sPath="$1" sName="$2"
    local sPassFile="${sPath}/${m_PKI_CA_DIRNAMES[private]}/${sName}.${m_SSL_EXTENTIONS[passwd]}"
    local sKeyFile="${sPath}/${m_PKI_CA_DIRNAMES[private]}/${sName}.${m_SSL_EXTENTIONS[key]}"
    local sCSRFile="${sPath}/${m_PKI_CA_DIRNAMES[certificatesigningrequests]}/${sName}.${m_SSL_EXTENTIONS[certificatesigningrequest]}"
    local sCertFile="${sPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sName}.${m_SSL_EXTENTIONS[certificate]}"
    local -i iReturn=1

    # Do the job
    String::notice -n "Create the '${sName}' certificate signing request:"
    openssl req -new -outform PEM -out "${sCSRFile}" -config "${m_PKI_CNF_DIR}/${sName}.conf" -key "${sKeyFile}" -keyform PEM -passin file:"${sPassFile}"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Main CA commands
## -----------------------------------------------------------------------------

PKI::RootLevel::main() {

    # Parameters
    if (($# < 1)); then
        PKI::RootLevel::showHelp
        return 1
    fi

    # Init
    local -i iReturn=1

    # Do the job
    case "$1" in
        reset) # Remove all PKI level repositories. Root CA, subordinate signing CAs and all issued certificates.
            PKI::reset "${m_PKI_CA_DIR}"
            iReturn=$?
            ;;
        init) # Create the CA repository, create the CA database files and create the password file for the CA private key.
            PKI::createRepository "${m_PKI_CA_DIR}/${m_PKI_CA_NAMES[root]}" "${m_PKI_CA_NAMES[root]}" &&\
                PKI::createDatabases "${m_PKI_CA_DIR}/${m_PKI_CA_NAMES[root]}" "${m_PKI_CA_NAMES[root]}"\
                PKI::createPasswordFile "${m_PKI_CA_DIR}/${m_PKI_CA_NAMES[root]}" "${m_PKI_CA_NAMES[root]}"
            iReturn=$?
            ;;
        create) # Create the Root Certificate
            PKI::generateKeypair "${m_PKI_CA_DIR}/${m_PKI_CA_NAMES[root]}" "${m_PKI_CA_NAMES[root]}" &&\
            PKI::generatePasswordedKeypair "${m_PKI_CA_DIR}/${m_PKI_CA_NAMES[root]}" "${m_PKI_CA_NAMES[root]}"
            ;;
        *)
            PKI::Simple::showHelp
            iReturn=$?
            ;;
    esac

    return ${iReturn}
}
