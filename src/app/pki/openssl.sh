## -----------------------------------------------------------------------------
## Linux Scripts.
## Public Key Infrastructure (PKI) management toolkit.
## OpenSSL common wrapper functions.
##
## @package ojullien\Shell\app\pki
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Verify key consistency
## -----------------------------------------------------------------------------
OpenSSL::viewKey() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: OpenSSL::viewKey <Key file>"
        return 1
    fi

    # Init
    local sKeyFile="$1"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sKeyFile}" ]]; then
        if ((m_OPTION_DISPLAY)); then
            String::separateLine
            openssl pkey -inform PEM -in "${sKeyFile}" -text_pub -noout -check
            iReturn=$?
            String::separateLine
        fi
    else
        String::error "Cannot check key: the key file '${sKeyFile}' does not exist."
    fi

    return ${iReturn}
}

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
        OpenSSL::viewKey "${sKeyFile}"
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Display the contents of CSR file in a human-readable output format
## -----------------------------------------------------------------------------
OpenSSL::viewRequest() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: OpenSSL::viewRequest <CSR file>"
        return 1
    fi

    # Init
    local sCsrFile="$1"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sCsrFile}" ]]; then
        if ((m_OPTION_DISPLAY)); then
            String::separateLine
            openssl req -noout -text -verify -in "${sCsrFile}" -nameopt multiline
            iReturn=$?
            String::separateLine
        fi
    else
        String::error "Cannot view request: the csr file '${sCsrFile}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Generates a new PKCS#10 certificate request using information specified in
## the [req] section of the configuration file.
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
    if [[ -f "${sKeyFile}" ]]; then
        String::notice -n "Create the '${sName}' certificate signing request:"
        openssl req -new -outform PEM -out "${sCsrFile}" -config "${m_PKI_CNF_DIR}/${sConf}" -key "${sKeyFile}" -keyform PEM
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        String::error "The key file does not exist: '${sKeyFile}'"
    fi

    # Inspecting the certificate's metadata
    if ((m_OPTION_DISPLAY)) && ((0==iReturn)); then
        OpenSSL::viewRequest "${sCsrFile}"
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Display the contents of a certificate file in a human-readable output format
## -----------------------------------------------------------------------------
OpenSSL::viewCertificate() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: OpenSSL::viewCertificate <CRT file>"
        return 1
    fi

    # Init
    local sCrtFile="$1"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sCrtFile}" ]]; then
        if ((m_OPTION_DISPLAY)); then
            String::separateLine
            openssl x509 -noout -text -purpose -inform PEM -in "${sCrtFile}"
            iReturn=$?
            String::separateLine
        fi
    else
        String::error "Cannot check certificate: the certificate file '${sCrtFile}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Create and self-sign the root CA certificate root based on the CSR.
## The openssl ca command takes its configuration from the [ca] section of the configuration file.
## -----------------------------------------------------------------------------
OpenSSL::createSelfSignedCertificate() {

    # Parameters
    if (($# != 3)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
        String::error "Usage: OpenSSL::createSelfSignedCertificate <CA path> <CA name> <configuration file name>"
        return 1
    fi

    # Init
    local sPath="$1" sName="$2" sConf="$3"
    local sKeyFile="${sPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sName}.${m_SSL_EXTENTIONS[key]}"
    local sCsrFile="${sPath}/${m_PKI_CA_DIRNAMES[certificatesigningrequests]}/${sName}.${m_SSL_EXTENTIONS[certificatesigningrequest]}"
    local sCrtFile="${sPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sName}.${m_SSL_EXTENTIONS[certificate]}"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sKeyFile}" ]] && [[ -f "${sCsrFile}" ]]; then
        String::notice -n "Create the self-signed '${sName}' certificate:"
        openssl ca -create_serial -selfsign -keyfile "${sKeyFile}" -keyform PEM -out "${sCrtFile}" -config "${m_PKI_CNF_DIR}/${sConf}" -in "${sCsrFile}"
        #openssl ca -create_serial -selfsign -keyfile "${sKeyFile}" -keyform PEM -out "${sCrtFile}"  -in "${sCsrFile}"
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        String::error "The key file '${sKeyFile}' or the csr file '${sCsrFile}' does not exist."
    fi

    # Inspecting the certificate's metadata
    if ((m_OPTION_DISPLAY)) && ((0==iReturn)); then
        OpenSSL::viewCertificate "${sCrtFile}"
    fi

    return ${iReturn}
}
