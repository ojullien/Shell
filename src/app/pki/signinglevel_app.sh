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
    String::notice "Available intermediate signing CA name:"
    for KEY in "${!!!!m_PKI_CA_SIGNING!!![@]}"; do
        String::notice "\t[$KEY]=\"${!!!m_PKI_CA_SIGNING!!![$KEY]}\""
    done
    return 0
}

## -----------------------------------------------------------------------------
## Main CA commands
## -----------------------------------------------------------------------------

PKI::SigningLevel::main() {

    # Parameters
    if (($# != 1)) || (($# != 2)); then
        PKI::SigningLevel::showHelp
        return 1
    fi

    # Init
    local sArg2="${2:-""}"
#    if [[ -z "${sArg2}" ]]; then
#        PKI::SigningLevel::showHelp
#        return 1
#    fi

    local sRootCAName="${m_PKI_CA_NAMES[root]}"
    local sRootCAConf="${m_PKI_CNF_DIR}/${m_PKI_CA_CONF_FILENAMES[root]}"
    local sRootCAPath="${m_PKI_CA_DIR}/${sRootCAName}"
    local sRootCAKeyFile="${sRootCAPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sRootCAName}.${m_SSL_FILE_EXTENTIONS[key]}"
    local sRootCACRTFile="${sRootCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sRootCAName}.${m_SSL_FILE_EXTENTIONS[certificate]}"
    local sRootCASRLFile="${sRootCAPath}/${m_PKI_CA_DIRNAMES[databases]}/${sRootCAName}${m_SSL_FILE_EXTENTIONS[serial]}"
    local sRootCAKeyCRTCombinedFile="${sRootCAPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sRootCAName}.key${m_SSL_FILE_EXTENTIONS[certificate]}"
    local sRootCAFriendlyName="${m_PKI_CA_FRIENDLYNAMES[root]}"

    local sSigningCAName="${m_PKI_CA_NAMES[${sArg2}]}"
    local sSigningCAConf="${m_PKI_CNF_DIR}/${m_PKI_CA_CONF_FILENAMES[${sArg2}]}"
    local sSigningCAPath="${m_PKI_CA_DIR}/${sSigningCAName}"
    local sSigningCAKeyFile="${sSigningCAPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sSigningCAName}.${m_SSL_FILE_EXTENTIONS[key]}"
    local sSigningCACSRFile="${sSigningCAPath}/${m_PKI_CA_DIRNAMES[certificatesigningrequests]}/${sSigningCAName}.${m_SSL_FILE_EXTENTIONS[certificatesigningrequest]}"
    local sSigningCACRTFile="${sSigningCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sSigningCAName}.${m_SSL_FILE_EXTENTIONS[certificate]}"
    local sSigningCASRLFile="${sSigningCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sSigningCAName}${m_SSL_FILE_EXTENTIONS[serial]}"
    local sSigningCAChainFile="${sSigningCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sSigningCAName}-chain.${m_SSL_FILE_EXTENTIONS[certificate]}"
    local sSigningCAP12File="${sSigningCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sSigningCAName}${m_SSL_FILE_EXTENTIONS[p12]}"
    local sSigningCAExtention="${m_PKI_CA_CONF_V3EXTENTIONS[signing]}"
    local sSigningCAFriendlyName="${m_PKI_CA_FRIENDLYNAMES[signing]}"
    local -i iReturn=1

    # Do the job
    case "$1" in

        remove|rm) # Remove the PKI signing CA level repository.
            PKI::remove "${sSigningCAPath}"
            iReturn=$?
            ;;

        initialize|init) # Create the CA repository and database files for the given CA (see app/pki/config.sh !!!m_PKI_CA_SIGNING!!! constant )
            PKI::createRepository "${sSigningCAPath}" "${sSigningCAName}"\
                && PKI::createDatabases "${sSigningCAPath}" "${sSigningCAName}"
            iReturn=$?
            ;;

        install) #
            MyOpenSSL::generateKeypair "${sSigningCAName}" "${sSigningCAKeyFile}"\
                && MyOpenSSL::createRequest "${sSigningCAName}" "${sSigningCAKeyFile}" "${sSigningCAConf}" "${sSigningCACSRFile}"\
                && MyOpenSSL::signCertificate "${sRootCACRTFile}" "${sRootCAKeyFile}" "${sRootCASRLFile}" "${sRootCAConf}" "${sSigningCAExtention}" "${sSigningCACSRFile}" "${sSigningCAName}" "${sSigningCACRTFile}" "${sSigningCAChainFile}"\
                && MyOpenSSL::bundleChain "${sSigningCAFriendlyName}" "${sSigningCACRTFile}" "${sSigningCAKeyFile}" "${sRootCAFriendlyName}" "${sRootCAKeyCRTCombinedFile}" "${sSigningCAP12File}"
            iReturn=$?
            ;;

        generate-key|key) # Generate a private and public key
            MyOpenSSL::generateKeypair "${sSigningCAName}" "${sSigningCAKeyFile}"
            iReturn=$?
            ;;

        generate-request|request|req) # Generate a new PKCS#10 certificate request from existing key
            MyOpenSSL::createRequest "${sSigningCAName}" "${sSigningCAKeyFile}" "${sSigningCAConf}" "${sSigningCACSRFile}"
            iReturn=$?
            ;;

        generate-signingca-certificate|signca) # Create the Signing CA certificate based on the CSR.
            MyOpenSSL::signCertificate "${sRootCACRTFile}" "${sRootCAKeyFile}" "${sRootCASRLFile}" "${sRootCAConf}" "${sSigningCAExtention}" "${sSigningCACSRFile}" "${sSigningCAName}" "${sSigningCACRTFile}" "${sSigningCAChainFile}"
            iReturn=$?
            ;;

        bundle) # Pack the private key and the certificate into a PKCS#12 bundle
            MyOpenSSL::bundleChain "${sSigningCAFriendlyName}" "${sSigningCACRTFile}" "${sSigningCAKeyFile}" "${sRootCAFriendlyName}" "${sRootCAKeyCRTCombinedFile}" "${sSigningCAP12File}"
            iReturn=$?
            ;;

        *)
            PKI::SigningLevel::showHelp
            iReturn=$?
            ;;
    esac

    return ${iReturn}
}
