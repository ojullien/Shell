## -----------------------------------------------------
## Linux Scripts.
## Root Configuration file.
##
## @category  Linux Scripts
## @package   Configuration
## @version   20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

#if [[ $EUID -ne 0 ]]; then
#    echo "Please run as root"
#    exit
#fi

if [ "$(id -u)" != "0" ]; then
   echo "Please run as root"
   error "This script must be run as root"
   exit 3
fi
