## -----------------------------------------------------
## Creates an apache user/group and a home directory in /var/www.
## App functions
##
## @category Linux Scripts
## @package createDomain
## @version 20180804
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

Domain::showHelp() {
    String::notice "Usage: $(basename $0) [options] <domain 1> [domain 2 ...]"
    String::notice "\tCreates an apache user/group and a home directory in /var/www"
    Option::showHelp
    String::notice "\t<domain 1>\tDomain name to create."
}

Domain::createGroup() {

    # Parameters
    if (($# != 1)) || [ -z "$1" ]; then
       String::error "Usage: Domain::createGroup <domain name>"
        exit 1
    fi

    # Init
    local sDomain="$1"
    local -i iReturn

    # Do the job
    String::notice "Creating '${sDomain}' group ..."
    adduser --force-badname --group "${sDomain}"
    iReturn=$?
    String::notice -n "Create '${sDomain}' group:"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

Domain::createUser() {

    # Parameters
    if (($# != 1)) || [ -z "$1" ]; then
       String::error "Usage: Domain::createUser <domain name>"
        exit 1
    fi

    # Init
    local sDomain="$1"
    local -i iReturn

    # Do the job
    String::notice "Creating '${sDomain}' user ..."
    adduser --quiet --no-create-home --disabled-password --disabled-login --force-badname --home "/var/www/${sDomain}" --shell /bin/false --ingroup="${sDomain}" "${sDomain}"
    iReturn=$?
    String::notice -n "Create '${sDomain}' user:"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

Domain::createDirectories() {

    # Parameters
    if (($# != 1)) || [ -z "$1" ]; then
       String::error "Usage: Domain::createDirectories <domain name>"
        exit 1
    fi

    # Init
    local sDomain="$1" sDirectory=""
    local -a aDirectories=( 'config' 'public' 'logs' 'tmp')
    local -i iReturn

    # Do the job
    for sDirectory in "${aDirectories[@]}"; do
        FileSystem::createDirectory "/var/www/${sDomain}/${sDirectory}"
        iReturn=$?
        ((0!=iReturn)) && return ${iReturn}
    done
    FileSystem::createDirectory "/var/log/apache2/${sDomain}"
    iReturn=$?

    return ${iReturn}
}

Domain::changeOwner() {

    # Parameters
    if (($# != 1)) || [ -z "$1" ]; then
        String::error "Usage: Domain::changeOwner <domain name>"
        exit 1
    fi

    # Init
    local sDomain="$1"
    local -i iReturn

    # Change owner/group and access right

    String::notice -n "Change '${sDomain}' file access right:"
    find "/var/www/${sDomain}/" -type f -exec chmod u=rw,g=r,o= {} \;
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}
    ((0!=iReturn)) && return ${iReturn}

    String::notice -n "Change '${sDomain}' folder access right:"
    find /var/www/${sDomain}/ -type d -exec chmod u=rwx,g=rx,o= {} \;
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}
    ((0!=iReturn)) && return ${iReturn}

    String::notice -n "Change '${sDomain}' owner:"
    chown -R $1:www-data /var/www/${sDomain}/
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

Domain::create() {

    # Parameters
    if (($# != 1)) || [ -z "$1" ]; then
       String::error "Usage: Domain::create <domain name>"
        exit 1
    fi

    # Init
    local sDomain="$1"
    local -i iReturn

    # Do the job
    Domain::createDirectories "${sDomain}"
    iReturn=$?
    ((0!=iReturn)) && return ${iReturn}

    Domain::createGroup "${sDomain}"
    iReturn=$?
    ((0!=iReturn)) && return ${iReturn}

    Domain::createUser "${sDomain}"
    iReturn=$?
    ((0!=iReturn)) && return ${iReturn}

    Domain::changeOwner "${sDomain}"
    iReturn=$?

    return ${iReturn}
}
