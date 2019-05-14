## -----------------------------------------------------------------------------
## Linux Scripts.
## Public Key Infrastructure (PKI) management toolkit.
## Certification level application.
## TLS certificates.
##
## @package ojullien\Shell\app\pki
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

PKI::User::showHelp() {
    String::notice "Usage: $(basename "$0") tls"
    String::notice "\tSigning CA application. We use intermediate signing CA to issue TLS, Email or Software certificates."
    String::notice "Available Commands:"
    String::notice "\tbundle\t\tPack the signing CA private key, the signing CA certificate and the Root CA PKCS#12 bundle into a new PKCS#12 bundle."
    String::notice "\tgenerate-key\t\tGenerate a signing CA private and signing CA public key."
    String::notice "\tgenerate-request\tGenerate a new PKCS#10 certificate request from existing signing CA key."
    String::notice "\thelp\t\t\tShow this help."
    String::notice "\tinitialize\t\tCreate the signing CA level repository and database files."
    String::notice "\tinstall\t\t\tGenerate the signing CA keypair, the signing CA certificate signing request then sign the signing level certificate and create the PKCS#12 bundle."
    String::notice "\tremove\t\t\tRemove the signing level repositories and issued certificates."
    String::notice "\tsignca\t\tCreate and sign the signing CA certificate based on the CSR."
    for KEY in "${!m_PKI_CA_NAMES[@]}"; do
        String::notice "\t[$KEY]=\"${m_PKI_CA_NAMES[$KEY]}\""
    done
    return 0
}

## -----------------------------------------------------------------------------
## Main CA commands
## -----------------------------------------------------------------------------

PKI::User::main() {

    # Parameters
    if (($# != 3)); then
        PKI::User::showHelp
        return 1
    fi

    # Init
    local sUserType="${1:-""}" sCommand="${2:-""}"  sUserName="${3:-""}"
    if [[ -z "${sCommand}" ]] || [[ -z "${sUserName}" ]] || [[ -z "${sUserType}" ]] || [[ ! -v "m_PKI_CA_CONF_V3EXTENTIONS[${sUserType}]" ]]; then
        PKI::User::showHelp
        return 1
    fi

#    local sRootCAName="${m_PKI_CA_NAMES[root]}"
#    local sRootCAConf="${m_PKI_CNF_DIR}/${m_PKI_CA_CONF_FILENAMES[root]}"
#    local sRootCAPath="${m_PKI_CA_DIR}/${sRootCAName}"
#    local sRootCAKeyFile="${sRootCAPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sRootCAName}.${m_SSL_FILE_EXTENTIONS[key]}"
#    local sRootCACRTFile="${sRootCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sRootCAName}.${m_SSL_FILE_EXTENTIONS[certificate]}"
#    local sRootCASRLFile="${sRootCAPath}/${m_PKI_CA_DIRNAMES[databases]}/${sRootCAName}${m_SSL_FILE_EXTENTIONS[serial]}"
#    local sRootCAKeyCRTCombinedFile="${sRootCAPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sRootCAName}.key${m_SSL_FILE_EXTENTIONS[certificate]}"
#    local sRootCAFriendlyName="${m_PKI_CA_FRIENDLYNAMES[root]}"

    local sSigningCAName="${m_PKI_CA_NAMES[signing]}"
#    local sSigningCAConf="${m_PKI_CNF_DIR}/${m_PKI_CA_CONF_FILENAMES[signing]}"
    local sSigningCAPath="${m_PKI_CA_DIR}/${sSigningCAName}"
    local sSigningCAKeyFile="${sSigningCAPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sSigningCAName}.${m_SSL_FILE_EXTENTIONS[key]}"
#    local sSigningCACSRFile="${sSigningCAPath}/${m_PKI_CA_DIRNAMES[certificatesigningrequests]}/${sSigningCAName}.${m_SSL_FILE_EXTENTIONS[certificatesigningrequest]}"
    local sSigningCACRTFile="${sSigningCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sSigningCAName}.${m_SSL_FILE_EXTENTIONS[certificate]}"
    local sSigningCASRLFile="${sSigningCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sSigningCAName}${m_SSL_FILE_EXTENTIONS[serial]}"
#    local sSigningCAChainFile="${sSigningCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sSigningCAName}-chain.${m_SSL_FILE_EXTENTIONS[certificate]}"
#    local sSigningCAP12File="${sSigningCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sSigningCAName}${m_SSL_FILE_EXTENTIONS[p12]}"
#    local sSigningCAExtention="${m_PKI_CA_CONF_V3EXTENTIONS[signing]}"
#    local sSigningCAFriendlyName="${m_PKI_CA_FRIENDLYNAMES[signing]}"
#    local -i iReturn=1

    local sUserConf="${m_PKI_CNF_DIR}/${sUserName}.conf"
    local sUserKeyFile="${sSigningCAPath}/${m_PKI_CA_DIRNAMES[privatekeys]}/${sUserName}.${m_SSL_FILE_EXTENTIONS[key]}"
    local sUserCSRFile="${sSigningCAPath}/${m_PKI_CA_DIRNAMES[certificatesigningrequests]}/${sUserName}.${m_SSL_FILE_EXTENTIONS[certificatesigningrequest]}"
    local sUserCRTFile="${sSigningCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sUserName}.${m_SSL_FILE_EXTENTIONS[certificate]}"
    local sUserChainFile="${sSigningCAPath}/${m_PKI_CA_DIRNAMES[signedcertificates]}/${sUserName}-chain.${m_SSL_FILE_EXTENTIONS[certificate]}"

    # Do the job
    case "${sCommand}" in

        generate-key|key) # Generate a private and public key
            MyOpenSSL::generateKeypair "${sUserName}" "${sUserKeyFile}"
            iReturn=$?
            ;;

        generate-request|request|req) # Generate a new PKCS#10 certificate request from existing key
            MyOpenSSL::createRequest "${sUserName}" "${sUserKeyFile}" "${sUserConf}" "${sUserCSRFile}"
            iReturn=$?
            ;;

        sign) # Create the certificate based on the CSR.
            MyOpenSSL::signCertificate "${sSigningCACRTFile}" "${sSigningCAKeyFile}" "${sSigningCASRLFile}" "${sUserConf}" "server_ext" "${sUserCSRFile}" "${sUserName}" "${sUserCRTFile}" "${sUserChainFile}"
            iReturn=$?
            ;;

        install) #
            MyOpenSSL::generateKeypair "${sUserName}" "${sUserKeyFile}"\
                && MyOpenSSL::createRequest "${sSigningCAName}" "${sSigningCAKeyFile}" "${sSigningCAConf}" "${sSigningCACSRFile}"\
                && MyOpenSSL::signCertificate "${sRootCACRTFile}" "${sRootCAKeyFile}" "${sRootCASRLFile}" "${sRootCAConf}" "${sSigningCAExtention}" "${sSigningCACSRFile}" "${sSigningCAName}" "${sSigningCACRTFile}" "${sSigningCAChainFile}"\
                && MyOpenSSL::bundleChain "${sSigningCAFriendlyName}" "${sSigningCACRTFile}" "${sSigningCAKeyFile}" "${sRootCAFriendlyName}" "${sRootCAKeyCRTCombinedFile}" "${sSigningCAP12File}"
            iReturn=$?
            ;;

        remove|rm) # Remove the PKI signing CA level repository.
            #PKI::remove "${sSigningCAPath}"
            iReturn=$?
            ;;

        trace)
            PKI::traceSigning
            iReturn=$?
            ;;

        *)
            PKI::User::showHelp
            iReturn=$?
            ;;
    esac

    return ${iReturn}
}
