## -----------------------------------------------------------------------------
## Linux Scripts.
## SaveDB app configuration file.
##
## @package ojullien\Shell\app\savesystemconf
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

# Remove these 3 lines once you have configured this file
echo "The 'app/savesystemconf/config.sh' file is not configured !!!"
String::error "The 'app/savesystemconf/config.sh' file is not configured !!!"
exit 3

## -----------------------------------------------------------------------------
## Test mariadb installed
## -----------------------------------------------------------------------------
readonly -i m_SAVEDB_ISMARIADB
m_SAVEDB_ISMARIADB=$(mysql --version | grep -c "MariaDB")

## -----------------------------------------------------------------------------
## Destination folder
## -----------------------------------------------------------------------------
readonly m_SAVEDB_DESTINATION_DEFAULT="/home/<user>"

## -----------------------------------------------------------------------------
## MySQL
## A user with the minimal rights needed to backup any database (BackupAdmin) + RELOAD + INSERT
## Global privileges: SELECT, INSERT, RELOAD, SHOW DATABASES, LOCK TABLES, EVENT
## -----------------------------------------------------------------------------
readonly m_DB_USR="<user>"
readonly m_DB_PWD="<***>"

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
SaveDB::trace() {
    String::separateLine
    String::notice "App configuration: saveDB"
    FileSystem::checkDir "\tDefault destination directory:\t${m_SAVEDB_DESTINATION_DEFAULT}" "${m_SAVEDB_DESTINATION_DEFAULT}"
    String::notice "\tMariaDB installed:${m_SAVEDB_ISMARIADB}"
    return 0
}
