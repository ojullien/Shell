## -----------------------------------------------------------------------------
## Linux Scripts.
## AutoSaveDatabase app configuration file.
##
## @package ojullien\Shell\app\autosavedb
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

# Remove these 3 lines once you have configured this file
echo "The 'app/autosavedb/config.sh' file is not configured !!!"
String::error "The 'app/autosavedb/config.sh' file is not configured !!!"
exit 3

## -----------------------------------------------------------------------------
## Test mariadb installed
## -----------------------------------------------------------------------------
readonly m_AUTOSAVEDB_ISMARIADB=$(mysql --version | grep -c "MariaDB")

## -----------------------------------------------------------------------------
## App Directories
## -----------------------------------------------------------------------------
readonly m_AUTOSAVEDB_UPLOAD_DIRECTORY_OWNER="<user>"

## -----------------------------------------------------------------------------
## App Directories
## -----------------------------------------------------------------------------

# Directory holds data to proceed
readonly m_AUTOSAVEDB_DIR_CACHE="/home/${m_AUTOSAVEDB_UPLOAD_DIRECTORY_OWNER}/out/autosavedb/cache"
# Directory holds data to transfert
readonly m_AUTOSAVEDB_DIR_UPLOAD="/home/${m_AUTOSAVEDB_UPLOAD_DIRECTORY_OWNER}/out/autosavedb/upload"

## -----------------------------------------------------------------------------
## List of databases to save
## -----------------------------------------------------------------------------
readonly -a m_AUTOSAVEDB_DATABASES=()

## -----------------------------------------------------------------------------
## MySQL
## A user with the minimal rights needed to backup any database (BackupAdmin) + RELOAD + INSERT
## Global privileges: SELECT, INSERT, RELOAD, SHOW DATABASES, LOCK TABLES, EVENT
## -----------------------------------------------------------------------------
readonly m_DB_USR="<user>"
readonly m_DB_PWD="<***>"

## -----------------------------------------------------------------------------
## Ftp
## -----------------------------------------------------------------------------
readonly m_FTP_SRV="<server.domain.net>"
readonly m_FTP_USR="<user>"
readonly m_FTP_PWD="<***>"

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
AutoSaveDB::trace() {
    String::separateLine
    String::notice "App configuration: AutoSaveDB"
    FileSystem::checkDir "\tCache directory:\t${m_AUTOSAVEDB_DIR_CACHE}" "${m_AUTOSAVEDB_DIR_CACHE}"
    FileSystem::checkDir "\tUpload directory:\t${m_AUTOSAVEDB_DIR_UPLOAD}" "${m_AUTOSAVEDB_DIR_UPLOAD}"
    String::notice "\tDatabases:\t\t${m_AUTOSAVEDB_DATABASES[*]}"
    return 0
}
