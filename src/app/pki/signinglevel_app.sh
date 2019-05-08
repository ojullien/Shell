## -----------------------------------------------------------------------------
## Linux Scripts.
## Public Key Infrastructure (PKI) management toolkit.
## Intermediate signing level application. We use intermediate signing CA to issue
## TLS certificates.
##
## @package ojullien\Shell\app\pki
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

PKI::SigningLevel::showHelp() {
    String::notice "Usage: $(basename "$0") SigningLevel <command> <intermediate signing CA name>"
    String::notice "\tSigning CA level application. We use intermediate signing CA to issue TLS certificates."
    String::notice "Available Commands:"
    String::notice "\thelp\tShow this help."
    String::notice "\tkey\tGenerate a private and public key."
    String::notice "\trequest\tGenerate a new PKCS#10 certificate request from existing key."
    String::notice "\tselfsign\tCreate and self-sign the root CA certificate root based on the CSR."
    return 0
}

## -----------------------------------------------------------------------------
## Main CA commands
## -----------------------------------------------------------------------------

PKI::SigningLevel::main() {

    # Parameters
    if (($# < 2)); then
        PKI::SigningLevel::showHelp
        return 1
    fi

    # Init
    local sArg2="${2:-""}"
    if [[ -z "${sArg2}" ]]; then
        PKI::SigningLevel::showHelp
        return 1
    fi
    local sCAName="${m_PKI_CA_SIGNING[${sArg2}]}"
    local sCAConf="${m_PKI_CA_CONF_NAMES[${sArg2}]}"
    local sCAPath="${m_PKI_CA_DIR}/${sCAName}"
    local sRootCAName="${m_PKI_CA_ROOT[name]}"
    local sRootCAConf="${m_PKI_CA_ROOT[conf]}"
    local sRootCAPath="${m_PKI_CA_DIR}/${sRootCAName}"
    local -i iReturn=1

    # Do the job
    case "$1" in

        remove) # Remove the PKI signing CA level repository.
            PKI::remove "${sCAPath}"
            iReturn=$?
            ;;

        initialize) # Create the CA repository and database files for the given CA (see app/pki/config.sh m_PKI_CA_NAMES constant )
            PKI::createRepository "${sCAPath}" "${sCAName}"
            iReturn=$?
            if ((0==iReturn)); then
                PKI::createDatabases "${sCAPath}" "${sCAName}"
                iReturn=$?
            fi
            ;;

        install) #
            OpenSSL::generateKeypair "${sCAPath}" "${sCAName}"
            iReturn=$?

            if ((0==iReturn)); then
                OpenSSL::createRequest "${sCAPath}" "${sCAName}" "${sCAConf}"
                iReturn=$?
            fi

            if ((0==iReturn)); then
                OpenSSL::createSelfSignedCertificate "${sCAPath}" "${sCAName}" "${sCAConf}"
                iReturn=$?
            fi
            ;;

        generate-key) # Generate a private and public key
            OpenSSL::generateKeypair "${sCAPath}" "${sCAName}"
            iReturn=$?
            ;;

        generate-request) # Generate a new PKCS#10 certificate request from existing key
            OpenSSL::createRequest "${sCAPath}" "${sCAName}" "${sCAConf}"
            iReturn=$?
            ;;

        generate-ca-certificate) # Create the Signing CA certificate based on the CSR.
            local sCACert="${sRootCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sRootCAName}.${m_SSL_EXTENTIONS[certificate]}"
            local sCAKey="${sRootCAPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sRootCAName}.${m_SSL_EXTENTIONS[key]}"
            local sCsrFile="${sCAPath}/${m_PKI_CA_DIRNAMES[certificatesigningrequests]}/${sCAName}.${m_SSL_EXTENTIONS[certificatesigningrequest]}"
            local sCrtFile="${sCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sCAName}.${m_SSL_EXTENTIONS[certificate]}"
            OpenSSL::signCertificate "${sCsrFile}" "${sCACert}" "${sCAKey}" "${sCrtFile}" "${sRootCAConf}" "signing_ca_ext" "${sCAName}"
            iReturn=$?
            ;;

        *)
            PKI::RootLevel::showHelp
            iReturn=$?
            ;;
    esac

    return ${iReturn}
}
