## -----------------------------------------------------------------------------
## Linux Scripts.
## Public Key Infrastructure (PKI) management toolkit.
## PKI common wrapper functions.
##
## @package ojullien\Shell\app\pki
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

PKI::showHelp() {
    String::notice "Usage: $(basename "$0") [options] [command]"
    String::notice "\tPKI toolkit"
    Option::showHelp
    String::notice "Available Commands:"
    String::notice "\trootlevel\tRoot CA level application."
    return 0
}

## -----------------------------------------------------------------------------
## Remove the content of a CA repository.
## -----------------------------------------------------------------------------
PKI::reset() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: PKI::reset <CA path>"
        return 1
    fi

    # Do the job
    FileSystem::cleanDirectory "$1"

    return $?
}

## -----------------------------------------------------------------------------
## Create a CA repository.
## -----------------------------------------------------------------------------
PKI::createRepository() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: PKI::createRepository <CA path> <CA name>"
        return 1
    fi

    # Init
    local sPath="$1" sName="$2"
    local -i iReturn=1

    # Do the job
    String::notice -n "Create '${sName}' repository: "
        mkdir --parents "${sPath}"/{"${m_PKI_CA_DIRNAMES[privatekeys]}","${m_PKI_CA_DIRNAMES[databases]}","${m_PKI_CA_DIRNAMES[signedcertificates]}","${m_PKI_CA_DIRNAMES[revokelist]}","${m_PKI_CA_DIRNAMES[certificatesigningrequests]}"}\
        && chmod 700 "${sPath}/${m_PKI_CA_DIRNAMES[privatekeys]}"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Create CA database files.
## The files must exist before the openssl ca command can be used.
## -----------------------------------------------------------------------------
PKI::createDatabases() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: PKI::createDatabases <CA path> <CA name>"
        return 1
    fi

    # Init
    local sPath="$1" sName="$2"
    local -i iReturn=1

    # Do the job
    String::notice -n "Create '${sName}' databases:"
    touch "${sPath}/${m_PKI_CA_DIRNAMES[databases]}/${sName}.index.txt"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Signes a certificate request using a RSA private key and information
## specified in the configuration file.
## -----------------------------------------------------------------------------

OldOpenSSL::createCertificate () {
    if [ $# -lt 5 -o -z "$1" -o -z "$2" -o -z "$3"  -o -z "$4" -o -z "$5" ]; then
        error "Usage: createsCertificate <configuration file> <certificate signing request to be signed> <private key to sign requests with> <certificate> <section of the configuration file containing certificate extensions> [-selfsign] [-key password] [-policy arg]"
        exit 1
    fi
    openssl ca -config $1 \
               -in $2 \
               -keyfile $3 \
               -keyform PEM \
               -out $4 \
               -extensions $5 $6 $7 $8 $9 $10
    return $?
}

## -----------------------------------------------------------------------------
## All published certificates must be in DER format.
## -----------------------------------------------------------------------------

OldOpenSSL::publishCertificate () {
    if [ $# -lt 2 -o -z "$1" -o -z "$2" ]; then
        error "Usage: publishCertificate <input filename to read a certificate from> <output filename to write to>"
        exit 1
    fi
    openssl x509 -inform PEM -outform DER -in $1 -out $2
    return $?
}

## -----------------------------------------------------------------------------
## Pack the private key and the certificate into a PKCS#12 bundle
## -----------------------------------------------------------------------------

OldOpenSSL::bundleCertificate () {
    if [ $# -lt 6 -o -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" -o -z "$5" -o -z "$6" ]; then
       error "Usage: bundleCertificate <friendly name> <filename to read certificates and private keys from> <file to read private key from> <password source> <pass phrase source to encrypt any outputted private keys with> <filename to write>"
        exit 1
    fi
    openssl pkcs12 -export \
                   -name "$1" \
                   -in $2 \
                   -inkey $3 \
                   -passin $4 \
                   -passout $5 \
                   -out $6
    return $?
}

## -----------------------------------------------------------------------------
## Create a list of revoked certificates
##    With the openssl ca -gencrl command we generate an
##    initial (empty) CRL
##    With the openssl crl command we generate a CRL in DER format
## -----------------------------------------------------------------------------

OldOpenSSL::createCRL () {
    if [ $# -lt 3 -o -z "$1" -o -z "$2" -o -z "$3" ]; then
        error "Usage: createCRL <configuration file> <private key to sign certificate with> <certificate revocation list>"
        exit 1
    fi

    openssl ca -gencrl \
               -config $1 \
               -keyfile $2 \
               -out $3 $4 $5

    openssl crl -in $3 \
                -out $3 \
                -outform der

    return $?
}

## -----------------------------------------------------------------------------
## Revokes a certificate
## -----------------------------------------------------------------------------

OldOpenSSL::revokeCertificate () {
    if [ $# -lt 3 -o -z "$1" -o -z "$2" -o -z "$3" ]; then
        error "Usage: revokeCertificate <configuration file> <certificate to revoke> <revocation reason>"
        exit 1
    fi
    openssl ca -config $1 \
               -revoke $2 \
               -crl_reason $3 $4 $5
    return $?
}

## -----------------------------------------------------------------------------
## Converts the RSA key from PKCS #8 (OpenSSL 1.0 and newer) to the old PKCS #1
## format .
## Mysql 5.5 needs key in PKCS #1 format.
## -----------------------------------------------------------------------------

OldOpenSSL::convertToPKCS1 () {
    if [ $# -lt 2 -o -z "$1" -o -z "$2" ]; then
        error "Usage: removePassphrase <input filename to read a key from> <output filename to write a key to> [-passin arg] [output file pass phrase source]"
        exit 1
    fi
    openssl rsa -inform PEM \
                -outform PEM \
                -in $1\
                -out $2 $3 $4 $5 $6
    return $?
}




OldOpenSSL::viewCRL () {
    if [ $# -lt 1 -o -z "$1" ]; then
        error "Usage: viewCRL <CRL file>"
        exit 1
    fi
    if [ -f $1 ]; then
        openssl crl -noout -text -inform DER -in $@
    fi
    return $?
}

OldOpenSSL::viewP12 () {
    if [ $# -lt 1 -o -z "$1" ]; then
        error "Usage: viewP12 <P12 certificate>"
        exit 1
    fi
    if [ -f $1 ]; then
        openssl pkcs12 -nodes -info -in $@
    fi
    return $?
}
