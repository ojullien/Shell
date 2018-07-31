## -----------------------------------------------------
## Linux Scripts.
## createDomain App functions
##
## @category  Linux Scripts
## @package   createDomain
## @version   20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

createGroup() {
    if [ $# -eq 0 ] || [ -z "$1" ]; then
       String::error "Usage: createGroup <group>"
        exit 1
    fi

    # Create group
    adduser --force-badname --group $1
    iReturn=$?
    if (( 0 == iReturn )); then
       String::success "Creating group $1."
    else
       String::error "ERROR: Can not create the group $1. code: ${iReturn}"
    fi

    return $iReturn
}

createUser() {
    if [ $# -eq 0 ] || [ -z "$1" ]; then
       String::error "Usage: createUser <user>"
        exit 1
    fi

    # Create user
    adduser --no-create-home --disabled-password --disabled-login --force-badname --home /var/www/$1 --shell /bin/false --ingroup=$1 $1
    iReturn=$?
    if (( 0 == iReturn )); then
       String::success "Creating user $1."
    else
       String::error "ERROR: Can not create the user $1. code: ${iReturn}"
    fi

    return $iReturn
}

FileSystem::createDirectory() {
    if [ $# -eq 0 ] || [ -z "$1" ]; then
       String::error "Usage: FileSystem::createDirectory <directory>"
        exit 1
    fi

    # Create the directory
    mkdir -p /var/www/$1/config && mkdir -p /var/www/$1/public && mkdir -p /var/www/$1/logs && mkdir -p /var/www/$1/tmp && mkdir -p /var/log/apache2/$1
    iReturn=$?
    if (( 0 == iReturn )); then
       String::success "Creating directory $1."
    else
       String::error "ERROR: Can not create the directory $1. code: ${iReturn}"
    fi

    return $iReturn
}

changeOwner() {
    if [ $# -eq 0 ] || [ -z "$1" ]; then
       String::error "Usage: changeOwner <owner>"
        exit 1
    fi

    # Change owner/group and access right
    find /var/www/$1/ -type f -exec chmod u=rw,g=r,o= {} \;
    find /var/www/$1/ -type d -exec chmod u=rwx,g=rx,o= {} \;
    chown -R $1:www-data /var/www/$1/
    iReturn=$?
    if (( 0 == iReturn )); then
       String::success "Changing owner/group and access right for $1."
    else
       String::error "ERROR: Can not change owner/group and access right for $1. code: ${iReturn}"
    fi

    return $iReturn
}
