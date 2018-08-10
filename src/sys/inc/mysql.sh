## -----------------------------------------------------
## Linux Scripts.
## Mysql database functions
##
## Requires MySQL 5.5 at least
##
## @category Linux Scripts
## @package Includes
## @version 20180804
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

Mysql::flush() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: Mysql::flush <user> <password>"
        exit 1
    fi

    # Init
    local sUser="$1" sPwd="$2"
    local -i iReturn=1

    # Do the job
    String::notice "Flushing all informations ..."
    mysqladmin --user="${sUser}" --password="${sPwd}" --host=localhost flush-hosts flush-logs flush-privileges flush-status flush-tables flush-threads
    iReturn=$?
    String::notice -n "Flush all informations:"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

Mysql::check() {

    # Parameters
    if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: Mysql::check <user> <password> [database]"
        exit 1
    fi

    # Init
    local sUser="$1" sPwd="$2" sDatabase=""
    local -i iReturn=1

    if [[ -z "$3" ]]; then
        sDatabase="--all-databases"
    else
        sDatabase="$3"
    fi

    # Do the job
    String::notice "Checking '${sDatabase}' ..."
    mysqlcheck --user="${sUser}" --password="${sPwd}" --host=localhost --check --auto-repair --force --silent ${sDatabase}
    iReturn=$?
    String::notice -n "Check '${sDatabase}':"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

Mysql::analyse() {

    # Parameters
    if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: Mysql::analyse <user> <password> [database]"
        exit 1
    fi

    # Init
    local sUser="$1" sPwd="$2" sDatabase=""
    local -i iReturn=1

    if [[ -z "$3" ]]; then
        sDatabase="--all-databases"
    else
        sDatabase="$3"
    fi

    # Do the job
    String::notice "Analysing '${sDatabase}' ..."
    mysqlcheck --user="${sUser}" --password="${sPwd}" --host=localhost --analyze --auto-repair --force --silent "${sDatabase}"
    iReturn=$?
    String::notice -n "Analyse '${sDatabase}':"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

Mysql::optimize() {

    # Parameters
    if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: Mysql::optimize <user> <password> [database]"
        exit 1
    fi

    # Init
    local sUser="$1" sPwd="$2" sDatabase=""
    local -i iReturn=1

    if [[ -z "$3" ]]; then
        sDatabase="--all-databases"
    else
        sDatabase="$3"
    fi

    # Do the job
    String::notice "Optimizing '${sDatabase}' ..."
    mysqlcheck --user="${sUser}" --password="${sPwd}" --host=localhost --optimize --force --silent "${sDatabase}"
    iReturn=$?
    String::notice -n "Optimize '${sDatabase}':"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

Mysql::repair() {

    # Parameters
    if (($# != 3)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
        String::error "Usage: Mysql::repair <user> <password> <database>"
        exit 1
    fi

    # Init
    local sUser="$1" sPwd="$2" sDatabase="$3"
    local -i iReturn=1

    # Do the job
    String::notice "Repairing '${sDatabase}' ..."
    mysqlcheck --user="${sUser}" --password="${sPwd}" --host=localhost --repair --flush --force --silent "${sDatabase}"
    iReturn=$?
    String::notice -n "Repair '${sDatabase}':"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

Mysql::dump() {

    # Parameters
    if (($# != 3)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
        String::error "Usage: Mysql::repair <user> <password> <database>"
        exit 1
    fi

    # Init
    local sUser="$1" sPwd="$2" sDatabase="$3"
    local -i iReturn=1

    # Do the job
    String::notice "Repairing '${sDatabase}' ..."
    mysqlcheck --user="${sUser}" --password="${sPwd}" --host=localhost --repair --flush --force --silent "${sDatabase}"
    iReturn=$?
    String::notice -n "Repair '${sDatabase}':"
    String::checkReturnValueForTruthiness ${iReturn}

mysqldump
--add-drop-database
--add-drop-table
--add-locks
--allow-keywords
--comments
--complete-insert
--create-options
--dump-date
--extended-insert
--flush-logs
--flush-privileges
--force
--hex-blob
--single-transaction
--max_allowed_packet=50M
--quick
--quote-names
--routines
--triggers
--tz-utc
--host=localhost
--log-error=name
--user=$m_MYSQLUSER
--password=$m_MYSQLPASSWD
--result-file=$2 $1

    return ${iReturn}
}
