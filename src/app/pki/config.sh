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
## Main folders
## -----------------------------------------------------------------------------
readonly m_SSL_DIR="/etc/ssl"
readonly m_PKI_CA_DIR="${m_SSL_DIR}/ca"
readonly -A m_PKI_CA_DIRNAMES=( [archive]="archive" [private]="private" [databases]="db" [certificates]="certs" );
readonly -A m_PKI_CA_CERTS_DIRNAMES=( [certificate]="crt" [revokelist]="crl" [signingrequest]="csr" );
readonly -A m_PKI_CA_NAMES=( [root]="root-ca" [tls]="tls-ca" );

## -----------------------------------------------------------------------------
## Main names
## -----------------------------------------------------------------------------
readonly m_SSL_EXTENTION_PASSWD="pass"
readonly m_SSL_EXTENTION_KEY="key.pem"

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
PKI::trace() {
    String::separateLine
    String::notice "App configuration: PKI"
    return 0
}
