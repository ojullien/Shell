## -----------------------------------------------------------------------------
## Linux Scripts.
## Public Key Infrastructure (PKI) management toolkit.
## Root CA level application. We use the root CA to issue subordinate signing CAs.
##
## @package ojullien\Shell\app\pki
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

PKI::RootLevel::showHelp() {
    String::notice "Usage: $(basename "$0") rootlevel [command]"
    String::notice "\tRoot CA level application. We use the root CA to issue subordinate signing CAs."
    String::notice "Available Commands:"
    String::notice "\tcreate\tCreate and self-sign the root CA certificate root based on the CSR."
    String::notice "\thelp\tShow this help."
    String::notice "\tinit\tInitialise the PKI repository."
    String::notice "\tkey\tGenerate a private and public key."
    String::notice "\trequest\tGenerate a new PKCS#10 certificate request from existing key."
    String::notice "\treset\tRemove all PKI level repositories. Root CA, subordinate signing CAs and all issued certificates."
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
    local -i iReturn=1

    # Do the job
    case "$1" in
        reset) # Remove all PKI level repositories. Root CA, subordinate signing CAs and all issued certificates.
            PKI::reset "${m_PKI_CA_DIR}"
            iReturn=$?
            ;;
        init) # Create the CA repository, create the CA database files and create the password file for the CA private key.
            PKI::createRepository "${m_PKI_CA_DIR}/${m_PKI_CA_NAMES[root]}" "${m_PKI_CA_NAMES[root]}"
            iReturn=$?
            if ((0==iReturn)); then
                PKI::createDatabases "${m_PKI_CA_DIR}/${m_PKI_CA_NAMES[root]}" "${m_PKI_CA_NAMES[root]}"
                iReturn=$?
            fi
            ;;
        key) # Generate a private and public key
            OpenSSL::generateKeypair "${m_PKI_CA_DIR}/${m_PKI_CA_NAMES[root]}" "${m_PKI_CA_NAMES[root]}"
            iReturn=$?
            ;;
        request) # Generate a new PKCS#10 certificate request from existing key
            OpenSSL::createRequest "${m_PKI_CA_DIR}/${m_PKI_CA_NAMES[root]}" "${m_PKI_CA_NAMES[root]}" "rootca.simple.conf"
            iReturn=$?
            ;;
        create) # Create and self-sign the root CA certificate root based on the CSR.
            OpenSSL::createSelfSignedCertificate "${m_PKI_CA_DIR}/${m_PKI_CA_NAMES[root]}" "${m_PKI_CA_NAMES[root]}" "rootca.simple.conf"
            iReturn=$?
            ;;
        *)
            PKI::RootLevel::showHelp
            iReturn=$?
            ;;
    esac

    return ${iReturn}
}
