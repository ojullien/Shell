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
            openssl x509 -noout -text -purpose -nameopt multiline -inform PEM -in "${sCrtFile}"
            iReturn=$?
            String::separateLine
        fi
    else
        String::error "Cannot check certificate: the certificate file '${sCrtFile}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Display the contents of a certificate file in a human-readable output format
## -----------------------------------------------------------------------------
OpenSSL::verifyCertificate() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$1" ]]; then
        String::error "Usage: OpenSSL::verifyCertificate <CA crt file> <CRT file>"
        return 1
    fi

    # Init
    local sCACrtFile="$1" sCrtFile="$2"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sCACrtFile}" ]] && [[ -f "${sCrtFile}" ]]; then
        if ((m_OPTION_DISPLAY)); then
            String::separateLine
            openssl verify -policy_check -x509_strict -verbose -CAfile "${sCACrtFile}" "${sCrtFile}"
            iReturn=$?
            String::separateLine
        fi
    else
        String::error "Cannot verify certificate: the certificate file '${sCrtFile}' or '${sCACrtFile}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Create and self-sign the root CA certificate root based on the CSR.
## The openssl ca command takes its configuration from the [ca] section of the configuration file.
## -----------------------------------------------------------------------------
OpenSSL::createSelfSignedCertificate() {

    # Parameters
    if (($# != 6)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]] || [[ -z "$5" ]]; then
        String::error "Usage: OpenSSL::createSelfSignedCertificate <csr file> <key file> <crt file> <conf file> <extention> <CA name>"
        return 1
    fi

    # Init
    local sCsrFile="$1" sKeyFile="$2" sCrtFile="$3" sConf="${m_PKI_CNF_DIR}/$4" sExtention="$5" sName="$6"
    local sSerial=$(openssl rand -hex 20)
    local -i iReturn=1

    # Do the job
    if [[ -f "${sKeyFile}" ]] && [[ -f "${sCsrFile}" ]] && [[ -f "${sConf}" ]]; then
        String::notice -n "Create the self-signed '${sName}' certificate:"
        openssl x509 -req -inform PEM -in "${sCsrFile}" -keyform PEM -signkey "${sKeyFile}" -days 365\
         -outform PEM -out "${sCrtFile}" -extfile "${sConf}" -extensions "${sExtention}" -set_serial 0x${sSerial}
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        String::error "The key file '${sKeyFile}', the csr file '${sCsrFile}' or the conf file '${sConf}' does not exist."
    fi

    # Inspecting the certificate's metadata
    if ((m_OPTION_DISPLAY)) && ((0==iReturn)); then
        OpenSSL::viewCertificate "${sCrtFile}"
        OpenSSL::verifyCertificate "${sCrtFile}" "${sCrtFile}"
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Sign a certificate request using a CA certificate.
## -----------------------------------------------------------------------------
OpenSSL::signCertificate() {

    # Parameters
    if (($# != 7)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]] || [[ -z "$5" ]]; then
        String::error "Usage: OpenSSL::signCertificate <csr file> <CA crt file> <CA key file> <crt file> <conf file> <extention> <name>"
        return 1
    fi

    # Init
    local sCsrFile="$1" sCACert="$2" sKeyFile="$3" sCrtFile="$4" sConf="${m_PKI_CNF_DIR}/$5" sExtention="$6" sName="$7"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sKeyFile}" ]] && [[ -f "${sCsrFile}" ]] && [[ -f "${sConf}" ]]; then
        String::notice -n "Create the self-signed '${sName}' certificate:"
        openssl x509 -req -inform PEM -in "${sCsrFile}" -CA "${sCACert}" -CAkey "${sKeyFile}" -days 365\
         -outform PEM -out "${sCrtFile}" -extfile "${sConf}" -extensions "${sExtention}" -CAcreateserial
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        String::error "The key file '${sKeyFile}', the csr file '${sCsrFile}', the CA crt file '${sCACert}' or the conf file '${sConf}' does not exist."
    fi

    # Inspecting the certificate's metadata
    if ((m_OPTION_DISPLAY)) && ((0==iReturn)); then
        OpenSSL::viewCertificate "${sCrtFile}"
        OpenSSL::verifyCertificate "${sCACert}" "${sCrtFile}"
    fi

    return ${iReturn}
}
