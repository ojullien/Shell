## -----------------------------------------------------
## Linux Scripts.
## Root Configuration file.
##
## @category Linux Scripts
## @package Configuration
## @version 20180804
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

if [[ ${BASH_VERSINFO[0]} -lt 4 ]]; then
    String::error "At least Bash version 4 is needed."
    exit 4
fi

#if [[ $EUID -ne 0 ]]; then
#    echo "Please run as root"
#    exit
#fi

if [ "$(id -u)" != "0" ]; then
   String::error "This script must be run as root"
   exit 3
fi
