## -----------------------------------------------------
## Save database
## App Configuration file.
##
## @category Linux Scripts
## @package SaveDB
## @version 20180811
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

# Remove these lines once you have configured this file
echo "The 'app/savedb/cfg/savedb.cfg.sh' file is not configured !!!"
String::error "The 'app/savedb/cfg/savedb.cfg.sh' file is not configured !!!"
exit 3

## -----------------------------------------------------
## Destination folder
## -----------------------------------------------------
declare m_SAVEDB_SAVEFOLDER="/home/<user>/out"

## -----------------------------------------------------
## MySQL
## A user with the minimal rights needed to backup any database (BackupAdmin) + RELOAD + INSERT
## Global privileges: SELECT, INSERT, RELOAD, SHOW DATABASES, LOCK TABLES, EVENT
## -----------------------------------------------------
readonly m_DB_USR="<user>"
readonly m_DB_PWD="<***>"

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
String::separateLine
String::notice "App configuration: saveDB"
FileSystem::checkDir "\tDefault save directory:\t${m_SAVEDB_SAVEFOLDER}" "${m_SAVEDB_SAVEFOLDER}"
