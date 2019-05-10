## -----------------------------------------------------------------------------
## Linux Scripts.
## OpenSSL common wrapper functions.
##
## @package ojullien\Shell\sys
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Verify key consistency
## -----------------------------------------------------------------------------
MyOpenSSL::viewKey() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: MyOpenSSL::viewKey <Key file>"
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
        String::error "MyOpenSSL::viewKey: file '${sKeyFile}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Generate a PKCS#8 private and public key using elliptic curves algorithm.
## -----------------------------------------------------------------------------
MyOpenSSL::generateKeypair() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: MyOpenSSL::generatePrivateKeypair <name> <key file>"
        return 1
    fi

    # Init
    local sKeyFile="$2" sName="$1"
    local -i iReturn=1

    # Do the job
    String::notice -n "generate '${sName}' keypair using elliptic curves algorithm:"
    openssl genpkey -out "${sKeyFile}" -outform PEM -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -pkeyopt ec_param_enc:named_curve \
        && chmod 444 "${sKeyFile}"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    # Inspecting the key's metadata
    if ((m_OPTION_DISPLAY)) && ((0==iReturn)); then
        MyOpenSSL::viewKey "${sKeyFile}"
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Display the contents of CSR file in a human-readable output format
## -----------------------------------------------------------------------------
MyOpenSSL::viewRequest() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: MyOpenSSL::viewRequest <CSR file>"
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
        String::error "MyOpenSSL::viewRequest: file '${sCsrFile}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Generates a new PKCS#10 certificate request using information specified in
## the [req] section of the configuration file.
## -----------------------------------------------------------------------------
MyOpenSSL::createRequest() {

    # Parameters
    if (($# != 4)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]]; then
        String::error "Usage: MyOpenSSL::createRequest <name> <key file> <configuration file> <csr file>"
        return 1
    fi

    # Init
    local sKeyFile="$2" sName="$1" sConf="$3" sCsrFile="$4"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sKeyFile}" ]] && [[ -f "${sConf}" ]]; then
        String::notice -n "Create the '${sName}' certificate signing request:"
        openssl req -new -outform PEM -out "${sCsrFile}" -config "${sConf}" -key "${sKeyFile}" -keyform PEM
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        String::error "MyOpenSSL::createRequest: file '${sKeyFile}' does not exist."
        String::error "MyOpenSSL::createRequest: file '${sConf}' does not exist."
    fi

    # Inspecting the certificate's metadata
    if ((m_OPTION_DISPLAY)) && ((0==iReturn)); then
        MyOpenSSL::viewRequest "${sCsrFile}"
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Display the contents of a certificate file in a human-readable output format
## -----------------------------------------------------------------------------
MyOpenSSL::viewCertificate() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: MyOpenSSL::viewCertificate <CRT file>"
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
        String::error "MyOpenSSL::viewCertificate: file '${sCrtFile}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Display the contents of a certificate file in a human-readable output format
## -----------------------------------------------------------------------------
MyOpenSSL::verifyCertificate() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$1" ]]; then
        String::error "Usage: MyOpenSSL::verifyCertificate <CA crt file> <CRT file>"
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
        String::error "MyOpenSSL::verifyCertificate: file '${sCACrtFile}' does not exist."
        String::error "MyOpenSSL::verifyCertificate: file '${sCrtFile}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Create and self-sign the root CA certificate root based on the CSR.
## The openssl ca command takes its configuration from the [ca] section of the configuration file.
## -----------------------------------------------------------------------------
MyOpenSSL::createSelfSignedCertificate() {

    # Parameters
    if (($# != 6)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]] || [[ -z "$5" ]]; then
        String::error "Usage: MyOpenSSL::createSelfSignedCertificate <csr file> <key file> <crt file> <conf file> <extention> <name>"
        return 1
    fi

    # Init
    local sCsrFile="$1" sKeyFile="$2" sCrtFile="$3" sConf="$4" sExtention="$5" sName="$6"
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
        String::error "MyOpenSSL::createSelfSignedCertificate: file '${sKeyFile}' does not exist."
        String::error "MyOpenSSL::createSelfSignedCertificate: file '${sCsrFile}' does not exist."
        String::error "MyOpenSSL::createSelfSignedCertificate: file '${sConf}' does not exist."
    fi

    # Inspecting the certificate's metadata
    if ((m_OPTION_DISPLAY)) && ((0==iReturn)); then
        MyOpenSSL::viewCertificate "${sCrtFile}"
        MyOpenSSL::verifyCertificate "${sCrtFile}" "${sCrtFile}"
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Sign a certificate request using a CA certificate.
## -----------------------------------------------------------------------------
MyOpenSSL::signCertificate() {

    # Parameters
    if (($# != 8)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]] || [[ -z "$5" ]] || [[ -z "$6" ]] || [[ -z "$7" ]] || [[ -z "$8" ]]; then
        String::error "Usage: MyOpenSSL::signCertificate <CA crt file> <CA key file> <CA serial file> <conf file> <extention> <csr file> <name> <crt file>"
        return 1
    fi

    # Init
    local sCACert="$1" sCAKey="$2" sCASerial="$3" sConf="$4" sExtention="$5" sCsrFile="$6" sName="$7" sCrtFile="$8"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sCAKey}" ]] && [[ -f "${sCsrFile}" ]] && [[ -f "${sConf}" ]] && [[ -f "${sCACert}" ]]; then
        String::notice -n "Create the self-signed '${sName}' certificate:"
        openssl x509 -req -inform PEM -in "${sCsrFile}" -CA "${sCACert}" -CAkey "${sCAKey}" -days 365\
         -outform PEM -out "${sCrtFile}" -extfile "${sConf}" -extensions "${sExtention}" -CAcreateserial -CAserial "${sCASerial}"
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        [[ -f "${sCsrFile}" ]] || String::error "MyOpenSSL::signCertificate: file '${sCsrFile}' does not exist."
        [[ -f "${sCACert}" ]] || String::error "MyOpenSSL::signCertificate: file '${sCACert}' does not exist."
        [[ -f "${sCAKey}" ]] || String::error "MyOpenSSL::signCertificate: file '${sCAKey}' does not exist."
        [[ -f "${sConf}" ]] || String::error "MyOpenSSL::signCertificate: file '${sConf}' does not exist."
    fi

    # Inspecting the certificate's metadata
    if ((m_OPTION_DISPLAY)) && ((0==iReturn)); then
        MyOpenSSL::viewCertificate "${sCrtFile}"
        MyOpenSSL::verifyCertificate "${sCACert}" "${sCrtFile}"
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Pack the private key and the certificate into a PKCS#12 bundle
## -----------------------------------------------------------------------------
MyOpenSSL::bundleCertificate() {

    # Parameters
    if (($# != 4)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]]; then
        String::error "Usage: MyOpenSSL::bundleCertificate <friendly name> < filename to read certificates and private keys from> <file to read private key from> <filename to write the PKCS#12 file to>"
        return 1
    fi

    # Init
    local sName="$1" sCrtFile="$2" sKeyFile="$3" sP12="$4"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sCrtFile}" ]] && [[ -f "${sKeyFile}" ]]; then
        String::notice -n "Create the PKCS#12 '${sName}' bundle:"
        openssl pkcs12 -export -name "${sName}" -in "${sCrtFile}" -inkey "${sKeyFile}" -out "${sP12}"
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        [[ -f "${sCrtFile}" ]] || String::error "MyOpenSSL::bundleCertificate: file '${sCrtFile}' does not exist."
        [[ -f "${sKeyFile}" ]] || String::error "MyOpenSSL::bundleCertificate: file '${sKeyFile}' does not exist."
    fi

    # Inspecting the certificate's metadata
    if ((m_OPTION_DISPLAY)) && ((0==iReturn)); then
        MyOpenSSL::viewCertificate "${sCrtFile}"
        MyOpenSSL::verifyCertificate "${sCACert}" "${sCrtFile}"
    fi

    return ${iReturn}

    if [ $# -lt 6 -o -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" -o -z "$5" -o -z "$6" ]; then
       error "Usage: bundleCertificate <friendly name> <filename to read certificates and private keys from> <file to read private key from> <password source> <pass phrase source to encrypt any outputted private keys with> <filename to write>"
        exit 1
    fi

    return $?
}
