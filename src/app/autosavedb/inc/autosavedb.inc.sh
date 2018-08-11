## -----------------------------------------------------
## Save Databases
## App functions
##
## @category Linux Scripts
## @package AutoSaveDB
## @version 20180811
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

declare -i m_APP_AUTOSAVEDB_ISMARIADB=$(mysql --version | grep -i "MariaDB" | wc -l)

if ((m_APP_AUTOSAVEDB_ISMARIADB)); then
    . "${m_DIR_SYS_INC}/mariadb.inc.sh"
else
    . "${m_DIR_SYS_INC}/mysql.inc.sh"
fi
