## -----------------------------------------------------------------------------
## Linux Scripts.
## Public Key Infrastructure (PKI) management toolkit.
## Configuration file.
##
## @package ojullien\Shell\app\pki
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

# Remove these 3 lines once you have configured this file
echo "The 'app/pki/config.sh' file is not configured !!!"
String::error "The 'app/pki/config.sh' file is not configured !!!"
exit 3

## -----------------------------------------------------------------------------
## Main folders and files
## -----------------------------------------------------------------------------
readonly m_SSL_DIR="/etc/ssl"
readonly m_PKI_CNF_DIR="${m_DIR_APP}/pki/cnf"

readonly m_PKI_CA_DIR="${m_SSL_DIR}/ca"
readonly -A m_PKI_CA_DIRNAMES=( [privatekeys]="private" [databases]="db" [signedcertificates]="newcerts" [revokelist]="crl" [certificatesigningrequests]="csr");

readonly -A m_SSL_FILE_EXTENTIONS=( [passwd]=".pass" [key]="key.pem" [certificate]="crt.pem" [certificatesigningrequest]="csr.pem" [index]=".txt" [serial]=".srl" [p12]=".p12");

## -----------------------------------------------------------------------------
## Main names
## -----------------------------------------------------------------------------

readonly -A m_PKI_CA_NAMES=( [root]="root-ca" [signing]="signing-ca" );
readonly -A m_PKI_CA_CONF_FILENAMES=( [root]="root-ca.conf" [signing]="signing-ca.conf" );
readonly -A m_PKI_CA_FRIENDLYNAMES=( [root]="Buster Root Certification Authority" [signing]="Buster Intermediate Signing Certification Authority" );
readonly -A m_PKI_CA_CONF_V3EXTENTIONS=( [root]="root_ca_ext" [signing]="signing_ca_ext" [tls]="server_ext" [email]="email_ext" [soft]="codesign_ext" );

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
PKI::traceRoot() {
    String::separateLine
    String::notice "PKI Root CA configuration:"

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

    FileSystem::checkFile "\tConf file is:\t\t\t${sRootCAConf}" "${sRootCAConf}"
    FileSystem::checkDir "\tDirectory:\t\t\t${sRootCAPath}" "${sRootCAPath}"
    FileSystem::checkFile "\tKey is:\t\t\t${sRootCAKeyFile}" "${sRootCAKeyFile}"
    FileSystem::checkFile "\tCSR is:\t\t\t${sRootCACSRFile}" "${sRootCACSRFile}"
    FileSystem::checkFile "\tCertificate is:\t\t\t${sRootCACRTFile}" "${sRootCACRTFile}"
    FileSystem::checkFile "\tSerial file is:\t\t\t${sRootCASRLFile}" "${sRootCASRLFile}"
    FileSystem::checkFile "\tCombined is:\t\t\t${sRootCAKeyCRTCombinedFile}" "${sRootCAKeyCRTCombinedFile}"
    FileSystem::checkFile "\tP12 file is:\t\t\t${sRootCAP12File}" "${sRootCAP12File}"
    String::notice "Extention is: ${sRootCAExtention}"
    String::notice "Friendly Name is: ${sRootCAFriendlyName}"

    return 0
}

PKI::trace() {
    PKI::traceRoot
    return 0
}
