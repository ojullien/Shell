## -----------------------------------------------------------------------------
## Linux Scripts.
## Public Key Infrastructure (PKI) management toolkit.
## OpenSSL common wrapper functions.
##
## @package ojullien\Shell\app\pki
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Generate a private and public key using elliptic curves algorithm.
## -----------------------------------------------------------------------------
OpenSSL::generateKeypair() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: OpenSSL::generatePrivateKeypair <CA path> <CA name>"
        return 1
    fi

    # Init
    local sPath="$1" sName="$2"
    local sKeyFile="${sPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sName}.${m_SSL_EXTENTIONS[key]}"
    local -i iReturn=1

    # Do the job
    String::notice -n "generate '${sName}' keypair using elliptic curves algorithm:"
    openssl genpkey -out "${sKeyFile}" -outform PEM -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -pkeyopt ec_param_enc:named_curve \
        && chmod 400 "${sKeyFile}"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    # Inspecting the key's metadata
    if ((m_OPTION_DISPLAY)) && ((0==iReturn)); then
        String::separateLine
        openssl pkey -inform PEM -in "${sKeyFile}" -text -noout
        String::separateLine
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Generates a new PKCS#10 certificate request using information specified in
## the configuration file.
## -----------------------------------------------------------------------------
OpenSSL::createRequest() {

    # Parameters
    if (($# != 3)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
        String::error "Usage: OpenSSL::createRequest <CA path> <CA name> <configuration file name>"
        return 1
    fi

    # Init
    local sPath="$1" sName="$2" sConf="$3"
    local sKeyFile="${sPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sName}.${m_SSL_EXTENTIONS[key]}"
    local sCsrFile="${sPath}/${m_PKI_CA_DIRNAMES[certificatesigningrequests]}/${sName}.${m_SSL_EXTENTIONS[certificatesigningrequest]}"
    local -i iReturn=1

    # Do the job
    String::notice -n "Create the '${sName}' certificate signing request:"
    openssl req -new -outform PEM -out "${sCsrFile}" -config "${m_PKI_CNF_DIR}/${sConf}" -key "${sKeyFile}" -keyform PEM
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    # Inspecting the key's metadata
    if ((m_OPTION_DISPLAY)) && ((0==iReturn)); then
        String::separateLine
        openssl req -noout -text -verify -in "${sCsrFile}"
        String::separateLine
    fi

    return ${iReturn}
}
