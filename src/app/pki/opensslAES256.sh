## -----------------------------------------------------------------------------
## Linux Scripts.
## Public Key Infrastructure (PKI) management toolkit.
## OpenSSL common wrapper functions using encrypted key
##
## @package ojullien\Shell\app\pki
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Generate an encrypted private and public key using elliptic curves algorithm
## and 256 bit AES
## -----------------------------------------------------------------------------
OpenSSL::generateKeypair() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: OpenSSL::generateKeypair <CA path> <CA name>"
        return 1
    fi

    # Init
    local sPath="$1" sName="$2"
    local sPassFile="${sPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sName}.${m_SSL_EXTENTIONS[passwd]}"
    local sKeyFile="${sPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sName}.${m_SSL_EXTENTIONS[key]}"
    local -i iReturn=1

    # Create password file
    String::notice -n "Generate '${sName}' password file:"
    openssl rand -out "${sPassFile}" -base64 16 && chmod 400 "${sFile}"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    # Do the job
    String::notice -n "generate encrypted '${sName}' keypair using elliptic curves algorithm:"
    openssl genpkey -out "${sKeyFile}" -outform PEM -pass file:"${sPassFile}" -aes-256-cbc -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -pkeyopt ec_param_enc:named_curve\
        && chmod 400 "${sKeyFile}"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    # Inspecting the key's metadata
    if ((m_OPTION_DISPLAY)) && ((0==iReturn)); then
        String::separateLine
        openssl pkey -inform PEM -in "${sKeyFile}" -pass file:"${sPassFile}" -text -noout
        String::separateLine
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Generates a new PKCS#10 certificate request using an encrypted key and
## information specified in the configuration file.
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
    local sPassFile="${sPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sName}.${m_SSL_EXTENTIONS[passwd]}"
    local -i iReturn=1

    # Do the job
    String::notice -n "Create the '${sName}' certificate signing request:"
    openssl req -new -outform PEM -out "${sCsrFile}" -config "${m_PKI_CNF_DIR}/${sConf}" -key "${sKeyFile}" -keyform PEM -passin file:"${sPassFile}"
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
