## -----------------------------------------------------------------------------
## Linux Scripts.
## Test of the filesystem functions
##
## @package ojullien\Shell\tests\sys
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Checks whether a directory exists
## -----------------------------------------------------------------------------

Test::FileSystem::checkDirTest() {
    local sValueToTest="$1"
    FileSystem::checkDir "Directory exists:\t${sValueToTest}" "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::checkDirErrorTest() {
    local sValueToTest="$1"
    FileSystem::checkDir "Directory does not exist:\t${sValueToTest}" "${sValueToTest}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Checks whether a file exists
## -----------------------------------------------------------------------------

Test::FileSystem::checkFileTest() {
    local sValueToTest=$(mktemp -p "${1}" -t tmp.XXXXXXXXXX)
    FileSystem::checkFile "File exists:\t${sValueToTest}" "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::checkFileErrorTest() {
    local sValueToTest="${1}/doesnotexist.sh"
    FileSystem::checkFile "File does not exist:\t${sValueToTest}" "${sValueToTest}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY
## -----------------------------------------------------------------------------

Test::FileSystem::copyFileTest() {
    local sSource="${1}"
    local sDestination="${2}"
    FileSystem::copyFile "${sSource}" "${sDestination}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::copyFileErrorTest() {
    local sSource="${1}"
    local sDestination="${2}"
    FileSystem::copyFile "${sSource}" "${sDestination}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Rename SOURCE to DEST, or move SOURCE(s) to DIRECTORY.
## -----------------------------------------------------------------------------

Test::FileSystem::moveFileTest() {
    local sSource="${1}"
    local sDestination="${2}"
    FileSystem::moveFile "${sSource}" "${sDestination}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::moveFileErrorTest() {
    local sSource="${1}"
    local sDestination="${2}"
    FileSystem::moveFile "${sSource}" "${sDestination}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Flush file system buffers
## -----------------------------------------------------------------------------

Test::FileSystem::syncFileTest() {
    FileSystem::syncFile
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Directories
## -----------------------------------------------------------------------------

Test::FileSystem::removeDirectoryTest() {
    local sValueToTest="${1}"
    FileSystem::removeDirectory "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::removeDirectoryErrorTest() {
    local sValueToTest="${1}"
    FileSystem::removeDirectory "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::cleanDirectoryTest() {

    # Init
    local -i iReturn=1
    local sDirPath=$(mktemp --directory -p "${1}" -t tmp.XXXXXXXXXX)
    local sFile01Path=$(mktemp -p "${sDirPath}" -t tmp.XXXXXXXXXX)
    local sFile02Path=$(mktemp -p "${sDirPath}" -t tmp.XXXXXXXXXX)

    # Do the job
    FileSystem::cleanDirectory "${sDirPath}"
    iReturn=$?
    FileSystem::syncFile
    if [[ -f "${sFile01Path}" ]] || [[ -f "${sFile02Path}" ]]; then
        iReturn=1
    fi
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::cleanDirectoryErrorTest() {
    local sValueToTest="${1}"
    FileSystem::cleanDirectory "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Compress
## -----------------------------------------------------------------------------

Test::FileSystem::compressFileTest() {

    # Init
    local sDirPath=$(mktemp --directory -p "${1}" -t tmp.XXXXXXXXXX)
    local sFile01Path=$(mktemp -p "${sDirPath}" -t tmp.XXXXXXXXXX)
    local sFile02Path=$(mktemp -p "${sDirPath}" -t tmp.XXXXXXXXXX)

    # Do the job
    FileSystem::compressFile "${1}/compressed" "${sDirPath}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::compressFileErrorTest() {
    FileSystem::compressFile "${1}/empty" "${1}/doesnotexist"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Find and remove files
## -----------------------------------------------------------------------------

Test::FileSystem::findToRemoveTest() {

    # Init
    local -i iReturn=1
    local sDirPath=$(mktemp --directory -p "${1}" -t tmp.XXXXXXXXXX)
    local sFile01Path=$(mktemp -p "${sDirPath}" -t tmp.XXXXXXXXXX)
    local sFile02Path=$(mktemp -p "${sDirPath}" -t tmp.XXXXXXXXXX)

    # Do the job
    FileSystem::findToRemove "${sDirPath}" "tmp.*"
    iReturn=$?
    FileSystem::syncFile
    if [[ -f "${sFile01Path}" ]] || [[ -f "${sFile02Path}" ]]; then
        iReturn=1
    fi
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Use lowerspace in namespace of the main function
## -----------------------------------------------------------------------------

Test::filesystem::main() {

    # Init
    local sTmpFolder=$(mktemp --directory -t tmp.XXXXXXXXXX)

    # Do the job

    String::separateLine
    String::notice "Testing: sys/filesystem ..."

    Test::FileSystem::checkDirTest "${sTmpFolder}"
    Test::FileSystem::checkDirErrorTest "${sTmpFolder}/doesnotexist"
    Test::FileSystem::checkFileTest "${sTmpFolder}"
    Test::FileSystem::checkFileErrorTest "${sTmpFolder}/doesnotexist.sh"

    # Keep the order
    Test::FileSystem::copyFileTest "${m_TEST_DIR_SYS}" "${sTmpFolder}"
    Test::FileSystem::copyFileErrorTest "${m_TEST_DIR_SYS}/doesnotexist" "${sTmpFolder}"
    Test::FileSystem::moveFileTest "${sTmpFolder}/sys" "${sTmpFolder}/delete_me"
    Test::FileSystem::moveFileErrorTest "${sTmpFolder}/doesnotexist" "${sTmpFolder}/delete_me_too"
    Test::FileSystem::syncFileTest
    Test::FileSystem::removeDirectoryTest "${sTmpFolder}/delete_me"
    Test::FileSystem::removeDirectoryErrorTest "${sTmpFolder}/doesnotexist"
    Test::FileSystem::cleanDirectoryTest "${sTmpFolder}"
    Test::FileSystem::cleanDirectoryErrorTest "${sTmpFolder}/doesnotexist"
    Test::FileSystem::compressFileTest "${sTmpFolder}"
    Test::FileSystem::compressFileErrorTest "${sTmpFolder}"
    Test::FileSystem::findToRemoveTest "${sTmpFolder}"
    rm -Rf "${sTmpFolder}"
}

function finish {
  echo hello finish
}
trap finish EXIT
