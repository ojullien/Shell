## -----------------------------------------------------------------------------
## Linux Scripts.
## Public Key Infrastructure (PKI) management toolkit.
## PKI common functions.
##
## @package ojullien\Shell\app\pki
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------



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
