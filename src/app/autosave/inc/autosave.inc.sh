## -----------------------------------------------------
## Linux Scripts.
## Autosave App functions
##
## @category    Linux Scripts
## @package     Autosave
## @version     20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

# Copies files over using FTP.
# @param    $1 = FTP Host
#           $2 = FTP User
#           $3 = FTP User password
#           $4 = Source file name
#           $5 = destination directory
#           $6 = local directory
putFTP() {
    if [ $# -lt 6 ] || [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ] || [ -z "$6" ]; then
        error "Usage: putFTP <FTP Host> <FTP User> <FTP User password> <Source file name> <destination directory> <local directory>"
        exit 1
    fi

    if [ $m_OPTION_LOG -eq 1 ]; then

        /usr/bin/ftp -pin $1 <<END_SCRIPT >> $m_LOGFILE 2> ftp.err.$$
quote USER $2
quote PASS $3
binary
cd  $5
lcd $6
put $4
close
quit
END_SCRIPT

    else
        /usr/bin/ftp -pin $1 <<END_SCRIPT 2> ftp.err.$$
quote USER $2
quote PASS $3
binary
cd  $5
lcd $6
put $4
close
quit
END_SCRIPT

    fi

    # Check error
    if [ 0 != $(wc -c < ftp.err.$$) ]; then
        iReturn=1
    else
        iReturn=0
    fi

    [ -f ftp.err.$$ ] && rm ftp.err.$$ 2>/dev/null;
    return $iReturn
}