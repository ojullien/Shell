## -----------------------------------------------------
## Linux Scripts.
## FTP functions
##
## @category Linux Scripts
## @package Includes
## @version 20180811
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

# Copies files over using FTP.
# @param    $1 = FTP Host
#           $2 = FTP User
#           $3 = FTP User password
#           $4 = Source file name
#           $5 = destination directory
#           $6 = local directory
FTP::put() {

    # Parameters
    if (($# != 6)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]] || [[ -z "$5" ]] || [[ -z "$6" ]]; then
        String::error "Usage: FTP::put <FTP Host> <FTP User> <FTP User password> <Source file name> <destination directory> <local directory>"
        exit 1
    fi

    # Init
    local sHost="$1" sUser="$2" sPass="$3" sFile="$4" sDestDir="$5" sLocalDir="$6"
    local -i iReturn=1 iWordCount=0

    # Do the job
    if ((m_OPTION_LOG)); then

        ftp -pin "${sHost}" <<END_SCRIPT >> "${m_LOGFILE}" 2> ftp.err.$$
quote USER ${sUser}
quote PASS ${sPass}
binary
cd ${sDestDir}
lcd ${sLocalDir}
put ${sFile}
close
quit
END_SCRIPT

    else
        ftp -pin "${sHost}" <<END_SCRIPT 2> ftp.err.$$
quote USER ${sUser}
quote PASS ${sPass}
binary
cd ${sDestDir}
lcd ${sLocalDir}
put ${sFile}
close
quit
END_SCRIPT

    fi

    # Check error
    iWordCount=$(wc -c < ftp.err.$$)
    if ((iWordCount)); then
        iReturn=1
    else
        iReturn=0
    fi

    [[ -f ftp.err.$$ ]] && rm ftp.err.$$ 2>/dev/null;

    return ${iReturn}
}
