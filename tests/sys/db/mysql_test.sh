## -----------------------------------------------------------------------------
## Linux Scripts.
## Test of the mysql functions
##
## @package ojullien\Shell\tests\sys
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

# shellcheck source=/dev/null
. "${m_DIR_SYS}/db/mysql.sh"

## -----------------------------------------------------------------------------
## Init
## -----------------------------------------------------------------------------
readonly m_TEST_DIR_TEMP="$(mktemp --directory -t shell.db.test.XXXXXXXXXX)"

Test::Mysql::flush() {
    local sUser="${1}"
    local sPassword="${2}"
    Mysql::flush "${sUser}" "${sPassword}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::Mysql::flushError() {
    local sUser="${1}"
    local sPassword="${2}"
    Mysql::flush "${sUser}" "${sPassword}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Mysql::check() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    Mysql::check "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::Mysql::checkAll() {
    local sUser="${1}"
    local sPassword="${2}"
    Mysql::check "${sUser}" "${sPassword}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::Mysql::checkError() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    Mysql::check "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Mysql::analyse() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    Mysql::analyse "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::Mysql::analyseAll() {
    local sUser="${1}"
    local sPassword="${2}"
    Mysql::analyse "${sUser}" "${sPassword}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::Mysql::analyseError() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    Mysql::analyse "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Mysql::optimize() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    Mysql::optimize "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::Mysql::optimizeAll() {
    local sUser="${1}"
    local sPassword="${2}"
    Mysql::optimize "${sUser}" "${sPassword}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::Mysql::optimizeError() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    Mysql::optimize "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Mysql::repair() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    Mysql::repair "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::Mysql::repairError() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    Mysql::repair "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Mysql::dump() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    local sErrorLogFile="${4}"
    local sResultFile="${5}"
    Mysql::dump "${sUser}" "${sPassword}" "${sDatabase}" "${sErrorLogFile}" "${sResultFile}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::Mysql::dumpError() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    local sErrorLogFile="${4}"
    local sResultFile="${5}"
    Mysql::dump "${sUser}" "${sPassword}" "${sDatabase}" "${sErrorLogFile}" "${sResultFile}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Use lowerspace in namespace of the main function
## -----------------------------------------------------------------------------

Test::mysql::main() {

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

    Test::Mysql::flush "${sUser}" "${sPassword}"
    Test::Mysql::flushError "${sUser}" "notvalid"

    Test::Mysql::check "${sUser}" "${sPassword}" "${sDatabase}"
    Test::Mysql::checkAll "${sUser}" "${sPassword}"
    Test::Mysql::checkError "${sUser}" "notvalid" "${sDatabase}"

    Test::Mysql::analyse "${sUser}" "${sPassword}" "${sDatabase}"
    Test::Mysql::analyseAll "${sUser}" "${sPassword}"
    Test::Mysql::analyseError "${sUser}" "notvalid" "${sDatabase}"

    Test::Mysql::optimize "${sUser}" "${sPassword}" "${sDatabase}"
    Test::Mysql::optimizeAll "${sUser}" "${sPassword}"
    Test::Mysql::optimizeError "${sUser}" "notvalid" "${sDatabase}"

    Test::Mysql::repair "${sUser}" "${sPassword}" "${sDatabase}"
    Test::Mysql::repairError "${sUser}" "${sPassword}" "doesnotexist"

    Test::Mysql::dump "${sUser}" "${sPassword}" "${sDatabase}" "${sErrorLogFile}" "${sResultFile}"
    Test::Mysql::dumpError "${sUser}" "${sPassword}" "doesnotexist" "${sErrorLogFile}" "${sResultFile}"

}

## -----------------------------------------------------------------------------
## End
## -----------------------------------------------------------------------------
Test::Mysql::finish() {
  rm -Rf "${m_TEST_DIR_TEMP}"
}
trap Test::Mysql::finish EXIT SIGQUIT ERR
