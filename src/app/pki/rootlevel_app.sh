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
    if (($# != 1)); then
        PKI::RootLevel::showHelp
        return 1
    fi

    # Init
    local sRootCAName="${m_PKI_CA_NAMES[root]}"
    local sRootCAConf="${m_PKI_CNF_DIR}/${m_PKI_CA_CONF_FILENAMES[root]}"
    local sRootCAPath="${m_PKI_CA_DIR}/${sRootCAName}"
    local sRootCAKeyFile="${sRootCAPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sRootCAName}.${m_SSL_FILE_EXTENTIONS[key]}"
    local sRootCACSRFile="${sRootCAPath}/${m_PKI_CA_DIRNAMES[certificatesigningrequests]}/${sRootCAName}.${m_SSL_FILE_EXTENTIONS[certificatesigningrequest]}"
    local sRootCACRTFile="${sRootCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sRootCAName}.${m_SSL_FILE_EXTENTIONS[certificate]}"
    local sRootCASRLFile="${sRootCAPath}/${m_PKI_CA_DIRNAMES[databases]}/${sRootCAName}${m_SSL_FILE_EXTENTIONS[serial]}"
    local sRootCAKeyCRTCombinedFile="${sRootCAPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sRootCAName}.key${m_SSL_FILE_EXTENTIONS[certificate]}"
    local sRootCAP12File="${sRootCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sRootCAName}${m_SSL_FILE_EXTENTIONS[p12]}"
    local sRootCAExtention="${m_PKI_CA_CONF_V3EXTENTIONS[root]}"
    local sRootCAFriendlyName="${m_PKI_CA_FRIENDLYNAMES[root]}"
    local -i iReturn=1

    # Do the job
    case "$1" in

        remove|rm) # Remove all PKI level repositories. Root CA, subordinate signing CAs and all issued certificates.
            PKI::remove "${m_PKI_CA_DIR}"
            iReturn=$?
            ;;

        initialize|init) # Create the root CA repository
            PKI::createRepository "${sRootCAPath}" "${sRootCAName}"\
                && PKI::createDatabases "${sRootCAPath}" "${sRootCAName}"
            iReturn=$?

            ;;

        install) #
            MyOpenSSL::generateKeypair "${sRootCAName}" "${sRootCAKeyFile}"\
                && MyOpenSSL::createRequest "${sRootCAName}" "${sRootCAKeyFile}" "${sRootCAConf}" "${sRootCACSRFile}"\
                && MyOpenSSL::createSelfSignedCertificate "${sRootCACSRFile}" "${sRootCAKeyFile}" "${sRootCACRTFile}" "${sRootCAConf}" "${sRootCAExtention}" "${sRootCAName}" "${sRootCAKeyCRTCombinedFile}"\
                && MyOpenSSL::bundleCertificate "${sRootCAFriendlyName}" "${sRootCACRTFile}" "${sRootCAKeyFile}" "${sRootCAP12File}"
            iReturn=$?
            ;;

        generate-key|key) # Generate a private and public key
            MyOpenSSL::generateKeypair "${sRootCAName}" "${sRootCAKeyFile}"
            iReturn=$?
            ;;

        generate-request|request|req) # Generate a new PKCS#10 certificate request from existing key
            MyOpenSSL::createRequest "${sRootCAName}" "${sRootCAKeyFile}" "${sRootCAConf}" "${sRootCACSRFile}"
            iReturn=$?
            ;;

        selfsign|self|sign|ss) # Create and self-sign the root CA certificate root based on the CSR.
            MyOpenSSL::createSelfSignedCertificate "${sRootCACSRFile}" "${sRootCAKeyFile}" "${sRootCACRTFile}" "${sRootCAConf}" "${sRootCAExtention}" "${sRootCAName}" "${sRootCAKeyCRTCombinedFile}"
            iReturn=$?
            ;;

        bundle) # Pack the private key and the certificate into a PKCS#12 bundle
            MyOpenSSL::bundleCertificate "${sRootCAFriendlyName}" "${sRootCACRTFile}" "${sRootCAKeyFile}" "${sRootCAP12File}"
            iReturn=$?
            ;;

        *)
            PKI::RootLevel::showHelp
            iReturn=$?
            ;;
    esac

    return ${iReturn}
}
