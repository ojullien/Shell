## -----------------------------------------------------------------------------
## Linux Scripts.
## Public Key Infrastructure (PKI) management toolkit.
## Sample minimal PKI Root level application.
##
## @package ojullien\Shell\app\pki
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

PKI::RootLevel::showHelp() {
    String::notice "Usage: $(basename "$0") rootlevel [command]"
    String::notice "\tSample minimal PKI Root level application."
    String::notice "Available Commands:"
    String::notice "\thelp\tShow this help."
    String::notice "\tinit\tInitialise the PKI Root level repository."
    String::notice "\treset\tDelete the PKI Root level repository."
    return 0
}

## -----------------------------------------------------------------------------
## Init functions
## -----------------------------------------------------------------------------

PKI::RootLevel::reset() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: PKI::RootLevel::reset <CA path>"
        return 1
    fi

    # Init
    local sPath="$1"
    local -i iReturn=1

    # Do the job
    FileSystem::cleanDirectory "${sPath}"
    iReturn=$?

    return ${iReturn}
}

PKI::RootLevel::initFolders() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: PKI::RootLevel::initFolders <CA path>"
        return 1
    fi

    # Init
    local sPath="$1"
    local -i iReturn=1

    # Do the job
    String::notice -n "Create '${sPath}/*' directories: "
    mkdir --parents ${sPath}/{${m_PKI_CA_DIRNAMES[archive]},${m_PKI_CA_DIRNAMES[private]},${m_PKI_CA_DIRNAMES[databases]},${m_PKI_CA_DIRNAMES[certificates]}/{${m_PKI_CA_CERTS_DIRNAMES[certificate]},${m_PKI_CA_CERTS_DIRNAMES[revokelist]},${m_PKI_CA_CERTS_DIRNAMES[signingrequest]}}}
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    if ((0==iReturn)); then
        String::notice -n "Change '${sPath}/${m_PKI_CA_DIRNAMES[private]}' mode:"
        chmod 700 "${sPath}/${m_PKI_CA_DIRNAMES[private]}"
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    fi

    return ${iReturn}
}

PKI::RootLevel::createPasswordFile() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: PKI::RootLevel::createPasswordFile <CA path> <CA name>"
        return 1
    fi

    # Init
    local sPath="$1" sName="$2"
    local sFile="${sPath}/${m_PKI_CA_DIRNAMES[private]}/${sName}.${m_SSL_EXTENTION_PASSWD}"
    local -i iReturn=1

    # Do the job
    String::notice -n "Generate '${sName}' password file:"
    openssl rand -out "${sFile}" -base64 16
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    if ((0==iReturn)); then
        String::notice -n "Changing mode:"
        chmod 400 "${sFile}"
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    fi

    return ${iReturn}
}

PKI::RootLevel::createDatabases() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: PKI::RootLevel::createDatabases <CA path> <CA name>"
        return 1
    fi

    # Init
    local sPath="$1" sName="$2"
    local -i iReturn=0

    # Do the job
    String::notice -n "Creating '${sName}' databases :"
    cp /dev/null "${sPath}/${m_PKI_CA_DIRNAMES[databases]}/${sName}.db"
    cp /dev/null "${sPath}/${m_PKI_CA_DIRNAMES[databases]}/${sName}.db.attr"
    echo 01 > "${sPath}/${m_PKI_CA_DIRNAMES[databases]}/${sName}.crt.srl"
    echo 01 > "${sPath}/${m_PKI_CA_DIRNAMES[databases]}/${sName}.crl.srl"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Create the Root Certificate
## -----------------------------------------------------------------------------

PKI::RootLevel::createPasswordedKeypairFile() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: PKI::RootLevel::createPasswordedKeypairFile <CA path> <CA name>"
        return 1
    fi

    # Init
    local sPath="$1" sName="$2"
    local sPassFile="${sPath}/${m_PKI_CA_DIRNAMES[private]}/${sName}.${m_SSL_EXTENTION_PASSWD}"
    local sKeyFile="${sPath}/${m_PKI_CA_DIRNAMES[private]}/${sName}"
    local -i iReturn=1

    # Do the job
#    String::notice -n "Generate the encrypted '${sPath}' private key:"
#    openssl genpkey -out "${sKeyFile}" -outform PEM -pass file:"${sPassFile}" -aes-256-cbc -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -pkeyopt ec_param_enc:named_curve
#    iReturn=$?
#    String::checkReturnValueForTruthiness ${iReturn}

    String::notice -n "Generate the '${sPath}' private key:"
    openssl genpkey -out "${sKeyFile}.p1.${m_SSL_EXTENTION_KEY}" -outform PEM -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -pkeyopt ec_param_enc:named_curve
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    String::notice -n "Convert the private key to PKCS#8 format using default parameters (AES with 256 bit key and hmacWithSHA256):"
    openssl pkcs8 -in "${sKeyFile}.${m_SSL_EXTENTION_KEY}" -topk8 -out "${sKeyFile}.p8.${m_SSL_EXTENTION_KEY}" -passout file:"${sPassFile}"
    iReturn+=$?
    String::checkReturnValueForTruthiness ${iReturn}

    String::notice -n "Convert the private key to PKCS#5 v2.0 format:"
    openssl pkcs8 -in "${sKeyFile}.${m_SSL_EXTENTION_KEY}" -topk8 -v2 aes-256-cbc -v2prf hmacWithSHA256 -out "${sKeyFile}.p5.${m_SSL_EXTENTION_KEY}" -passout file:"${sPassFile}"
    iReturn+=$?
    String::checkReturnValueForTruthiness ${iReturn}

    String::notice -n "Convert the private key to PKCS#8 using a PKCS#12 compatible algorithm:"
    openssl pkcs8 -in "${sKeyFile}.${m_SSL_EXTENTION_KEY}" -topk8 -v1 PBE-SHA1-3DES -out "${sKeyFile}.p12.${m_SSL_EXTENTION_KEY}" -passout file:"${sPassFile}"
    iReturn+=$?
    String::checkReturnValueForTruthiness ${iReturn}

    String::notice -n "Change mode:"
    chmod 400 "${sKeyFile}"
    iReturn+=$?
    String::checkReturnValueForTruthiness ${iReturn}

    if ((m_OPTION_DISPLAY)) && ((0==iReturn)); then
        for sFormat in {"p1","p8","p5","p12"}; do
            openssl pkey -inform PEM -in "${sKeyFile}.${sFormat}.${m_SSL_EXTENTION_KEY}" -passin file:"${sPassFile}" -text -noout
        done
   fi

    return ${iReturn}
}

PKI::RootLevel::createSelfSignedRootCertificateFile() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: PKI::RootLevel::createSelfSignedRootCertificateFile <CA path> <CA name>"
        return 1
    fi

    # Init
    local sPath="$1" sName="$2"
    local sPassFile="${sPath}/${m_PKI_CA_DIRNAMES[private]}/${sName}.${m_SSL_EXTENTION_PASSWD}"
    local sKeyFile="${sPath}/${m_PKI_CA_DIRNAMES[private]}/${sName}.${m_SSL_EXTENTION_KEY}"
    local sCertFile="${sPath}/${m_PKI_CA_DIRNAMES[private]}/${sName}.${m_SSL_EXTENTION_KEY}"
    local -i iReturn=1

    # Do the job
    String::notice -n "Generate the '${sPath}' private key:"
    openssl genpkey -out "${sKeyFile}" -outform PEM -pass file:"${sPassFile}" -aes-256-cbc -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -pkeyopt ec_param_enc:named_curve
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    if ((0==iReturn)); then
        String::notice -n "Change mode:"
        chmod 400 "${sKeyFile}"
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    fi

    if ((m_OPTION_DISPLAY)) && ((0==iReturn)); then
        openssl pkey -inform PEM -in "${sKeyFile}" -passin file:"${sPassFile}" -text -noout
   fi

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
        reset) # Remove all CA repository
            PKI::RootLevel::reset "${m_PKI_CA_DIR}"
            iReturn=$?
            ;;
        init) # Initialise CA repository
            PKI::RootLevel::initFolders "${m_PKI_CA_DIR}" &&\
                PKI::RootLevel::createPasswordFile "${m_PKI_CA_DIR}" "${m_PKI_CA_NAMES[root]}" &&\
                PKI::RootLevel::createDatabases "${m_PKI_CA_DIR}" "${m_PKI_CA_NAMES[root]}"
            iReturn=$?
            ;;
        create) # Create the Root Certificate
            PKI::RootLevel::createPasswordedKeypairFile "${m_PKI_CA_DIR}" "${m_PKI_CA_NAMES[root]}"
            ;;
        *)
            PKI::RootLevel::showHelp
            iReturn=$?
            ;;
    esac

    return ${iReturn}
}
