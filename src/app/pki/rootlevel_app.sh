## -----------------------------------------------------------------------------
## Linux Scripts.
## Public Key Infrastructure (PKI) management toolkit.
## Root CA level application. We use the root CA to issue subordinate signing CAs.
##
## @package ojullien\Shell\app\pki
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

PKI::RootLevel::showHelp() {
    String::notice "Usage: $(basename "$0") rootlevel <command>"
    String::notice "\tRoot CA level application. We use the root CA to issue subordinate signing CAs."
    String::notice "Available Commands:"
    String::notice "\tgenerate-key\t\tGenerate a private and public key."
    String::notice "\tgenerate-request\tGenerate a new PKCS#10 certificate request from existing key."
    String::notice "\thelp\t\t\tShow this help."
    String::notice "\tinitialize\t\tCreate the root CA level repository and database files."
    String::notice "\tinstall\t\t\tGenerate the keypair, the certificate signing request and the self-sign the root level certificate."
    String::notice "\tremove\t\t\tRemove all PKI level repositories. Root CA, subordinate signing CAs and all issued certificates."
    String::notice "\tselfsign\t\tCreate and self-sign the root CA certificate root based on the CSR."
    return 0
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
    local sCAName="${m_PKI_CA_ROOT[name]}"
    local sCAConf="${m_PKI_CNF_DIR}/${m_PKI_CA_ROOT[conf]}"
    local sCAPath="${m_PKI_CA_DIR}/${sCAName}"
    local sKeyFile="${sCAPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sCAName}.${m_SSL_EXTENTIONS[key]}"
    local sCsrFile="${sCAPath}/${m_PKI_CA_DIRNAMES[certificatesigningrequests]}/${sCAName}.${m_SSL_EXTENTIONS[certificatesigningrequest]}"
    local sCrtFile="${sCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sCAName}.${m_SSL_EXTENTIONS[certificate]}"
    local -i iReturn=1


    # Do the job
    case "$1" in

        remove) # Remove all PKI level repositories. Root CA, subordinate signing CAs and all issued certificates.
            PKI::remove "${m_PKI_CA_DIR}"
            iReturn=$?
            ;;

        initialize) # Create the root CA repository
            PKI::createRepository "${sCAPath}" "${sCAName}"
            iReturn=$?
            if ((0==iReturn)); then
                PKI::createDatabases "${sCAPath}" "${sCAName}"
                iReturn=$?
            fi
            ;;

        install) #
            MyOpenSSL::generateKeypair "${sCAName}" "${sKeyFile}"
            iReturn=$?

            if ((0==iReturn)); then
                MyOpenSSL::createRequest "${sCAName}" "${sKeyFile}" "${sCAConf}" "${sCsrFile}"
                iReturn=$?
            fi

            if ((0==iReturn)); then
                MyOpenSSL::createSelfSignedCertificate "${sCsrFile}" "${sKeyFile}" "${sCrtFile}" "${sCAConf}" "root_ca_ext" "${sCAName}"
                iReturn=$?
            fi
            ;;

        generate-key) # Generate a private and public key
            MyOpenSSL::generateKeypair "${sCAName}" "${sKeyFile}"
            iReturn=$?
            ;;

        generate-request) # Generate a new PKCS#10 certificate request from existing key
            MyOpenSSL::createRequest "${sCAName}" "${sKeyFile}" "${sCAConf}" "${sCsrFile}"
            iReturn=$?
            ;;

        selfsign) # Create and self-sign the root CA certificate root based on the CSR.
            MyOpenSSL::createSelfSignedCertificate "${sCsrFile}" "${sKeyFile}" "${sCrtFile}" "${sCAConf}" "root_ca_ext" "${sCAName}"
            iReturn=$?
            ;;

        *)
            PKI::RootLevel::showHelp
            iReturn=$?
            ;;
    esac

    return ${iReturn}
}
