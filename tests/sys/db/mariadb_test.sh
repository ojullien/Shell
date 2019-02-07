## -----------------------------------------------------------------------------
## Linux Scripts.
## Test of the mariadb functions
##
## @package ojullien\Shell\tests\sys
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

# shellcheck source=/dev/null
. "${m_DIR_SYS}/db/mariadb.sh"

## -----------------------------------------------------------------------------
## Init
## -----------------------------------------------------------------------------
readonly m_TEST_DIR_TEMP="$(mktemp --directory -t shell.db.test.XXXXXXXXXX)"

Test::MariaDB::flush() {
    local sUser="${1}"
    local sPassword="${2}"
    MariaDB::flush "${sUser}" "${sPassword}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::MariaDB::flushError() {
    local sUser="${1}"
    local sPassword="${2}"
    MariaDB::flush "${sUser}" "${sPassword}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::MariaDB::check() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    MariaDB::check "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::MariaDB::checkAll() {
    local sUser="${1}"
    local sPassword="${2}"
    MariaDB::check "${sUser}" "${sPassword}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::MariaDB::checkError() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    MariaDB::check "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::MariaDB::analyse() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    MariaDB::analyse "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::MariaDB::analyseAll() {
    local sUser="${1}"
    local sPassword="${2}"
    MariaDB::analyse "${sUser}" "${sPassword}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::MariaDB::analyseError() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    MariaDB::analyse "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::MariaDB::optimize() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    MariaDB::optimize "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::MariaDB::optimizeAll() {
    local sUser="${1}"
    local sPassword="${2}"
    MariaDB::optimize "${sUser}" "${sPassword}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::MariaDB::optimizeError() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    MariaDB::optimize "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::MariaDB::repair() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    MariaDB::repair "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::MariaDB::repairError() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    MariaDB::repair "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::MariaDB::dump() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    local sErrorLogFile="${4}"
    local sResultFile="${5}"
    MariaDB::dump "${sUser}" "${sPassword}" "${sDatabase}" "${sErrorLogFile}" "${sResultFile}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::MariaDB::dumpError() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    local sErrorLogFile="${4}"
    local sResultFile="${5}"
    MariaDB::dump "${sUser}" "${sPassword}" "${sDatabase}" "${sErrorLogFile}" "${sResultFile}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Use lowerspace in namespace of the main function
## -----------------------------------------------------------------------------

Test::mariadb::main() {

    # Init
    local sUser sPassword sDatabase sErrorLogFile sResultFile
    sUser="root"
    sPassword="<password>"
    sDatabase="<database>"
    sErrorLogFile="$(mktemp -p "${m_TEST_DIR_TEMP}")"
    sResultFile="$(mktemp -p "${m_TEST_DIR_TEMP}")"

    # Do the job
    String::separateLine
    String::notice "Testing: sys/db/mysql ..."

    Test::MariaDB::flush "${sUser}" "${sPassword}"
    Test::MariaDB::flushError "${sUser}" "notvalid"

    Test::MariaDB::check "${sUser}" "${sPassword}" "${sDatabase}"
    Test::MariaDB::checkAll "${sUser}" "${sPassword}"
    Test::MariaDB::checkError "${sUser}" "notvalid" "${sDatabase}"

    Test::MariaDB::analyse "${sUser}" "${sPassword}" "${sDatabase}"
    Test::MariaDB::analyseAll "${sUser}" "${sPassword}"
    Test::MariaDB::analyseError "${sUser}" "notvalid" "${sDatabase}"

    Test::MariaDB::optimize "${sUser}" "${sPassword}" "${sDatabase}"
    Test::MariaDB::optimizeAll "${sUser}" "${sPassword}"
    Test::MariaDB::optimizeError "${sUser}" "notvalid" "${sDatabase}"

    Test::MariaDB::repair "${sUser}" "${sPassword}" "${sDatabase}"
    Test::MariaDB::repairError "${sUser}" "${sPassword}" "doesnotexist"

    Test::MariaDB::dump "${sUser}" "${sPassword}" "${sDatabase}" "${sErrorLogFile}" "${sResultFile}"
    Test::MariaDB::dumpError "${sUser}" "${sPassword}" "doesnotexist" "${sErrorLogFile}" "${sResultFile}"

}

## -----------------------------------------------------------------------------
## End
## -----------------------------------------------------------------------------
Test::MariaDB::finish() {
  rm -Rf "${m_TEST_DIR_TEMP}"
}
trap Test::MariaDB::finish EXIT SIGQUIT ERR
