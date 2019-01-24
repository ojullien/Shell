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
    local sValueToTest="${m_TEST_DIR_SYS}"
    FileSystem::checkDir "Directory exists:\t${sValueToTest}" "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::checkDirErrorTest() {
    local sValueToTest="${m_TEST_DIR_SYS}/doesnotexist"
    FileSystem::checkDir "Directory does not exist:\t${sValueToTest}" "${sValueToTest}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Checks whether a file exists
## -----------------------------------------------------------------------------

Test::FileSystem::checkFileTest() {
    local sValueToTest="${m_TEST_DIR_SYS}/filesystem_test.sh"
    FileSystem::checkFile "File exists:\t${sValueToTest}" "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::checkFileErrorTest() {
    local sValueToTest="${m_TEST_DIR_SYS}/doesnotexist.sh"
    FileSystem::checkFile "File does not exist:\t${sValueToTest}" "${sValueToTest}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY
## -----------------------------------------------------------------------------

Test::FileSystem::copyFileTest() {
    local sSource="${m_TEST_DIR_SYS}"
    local sDestination="${m_LOGDIR}"
    FileSystem::copyFile "${sSource}" "${sDestination}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::copyFileErrorTest() {
    local sSource="${m_TEST_DIR_SYS}/doesnotexist"
    local sDestination="${m_LOGDIR}"
    FileSystem::copyFile "${sSource}" "${sDestination}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Rename SOURCE to DEST, or move SOURCE(s) to DIRECTORY.
## -----------------------------------------------------------------------------

Test::FileSystem::moveFileTest() {
    local sSource="${m_LOGDIR}/sys"
    local sDestination="${m_LOGDIR}/delete_me"
    FileSystem::moveFile "${sSource}" "${sDestination}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::moveFileErrorTest() {
    local sSource="${m_LOGDIR}/doesnotexist"
    local sDestination="${m_LOGDIR}/delete_me_too"
    FileSystem::moveFile "${m_TEST_DIR_SCRIPT}/log/doesnotexist" "${m_TEST_DIR_SCRIPT}/log/delete_me_too"
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
    local sValueToTest="${m_LOGDIR}/delete_me"
    FileSystem::removeDirectory "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::removeDirectoryErrorTest() {
    local sValueToTest="${m_LOGDIR}/doesnotexist"
    FileSystem::removeDirectory "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::cleanDirectoryTest() {
    local sDirPath="${m_LOGDIR}/delete_me"
    local sFile01Path="${sDirPath}/file01.txt"
    local sFile02Path="${sDirPath}/file02.txt"
    mkdir -p "${sDirPath}"
    touch "${sFile01Path}" "${sFile02Path}"
    FileSystem::cleanDirectory "${sDirPath}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
    if [[ -f ${sFile01Path} ]] || [[ -f ${sFile02Path} ]]; then
        String::error "Test::FileSystem::cleanDirectoryTest failure."
    fi
    rm -Rf "${sDirPath}"
}

Test::FileSystem::cleanDirectoryErrorTest() {
    local sValueToTest="${m_LOGDIR}/doesnotexist"
    FileSystem::cleanDirectory "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Compress
## -----------------------------------------------------------------------------

Test::FileSystem::compressFileTest() {
    local sDirPath="${m_LOGDIR}/compress_me"
    local sFile01Path="${m_LOGDIR}/file01.txt"
    local sFile02Path="${m_LOGDIR}/file02.txt"
    mkdir -p "${sDirPath}"
    touch "${sFile01Path}" "${sFile02Path}"
    FileSystem::compressFile "${m_LOGDIR}/compressed" "${sDirPath}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
    rm -Rf "${sDirPath}" "${m_LOGDIR}/compressed.tar.bz2"
}

Test::FileSystem::compressFileErrorTest() {
    FileSystem::compressFile "${m_LOGDIR}/empty" "${m_LOGDIR}/doesnotexist"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
    rm -f "${m_LOGDIR}/empty.tar.bz2"
}

## -----------------------------------------------------------------------------
## Find and remove files
## -----------------------------------------------------------------------------

Test::FileSystem::findToRemoveTest() {
    local sDirPath="${m_LOGDIR}/delete_me"
    local sFile01Path="${m_LOGDIR}/file01.txt"
    local sFile02Path="${m_LOGDIR}/file02.txt"
    mkdir -p "${sDirPath}"
    touch "${sFile01Path}" "${sFile02Path}"
    FileSystem::findToRemove "${m_LOGDIR}" "*.txt"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
    if [[ -f ${sFile01Path} ]] || [[ -f ${sFile02Path} ]]; then
        String:error "Test::FileSystem::findToRemoveTest failure."
    fi
    rm -Rf "${sDirPath}"
}

## -----------------------------------------------------------------------------
##
## -----------------------------------------------------------------------------

Test::FileSystem::main() {
    String::separateLine
    String::notice "Testing: sys/filesystem ..."
    Test::FileSystem::checkDirTest
    Test::FileSystem::checkDirErrorTest
    Test::FileSystem::checkFileTest
    Test::FileSystem::checkFileErrorTest
    # Keep the order
    Test::FileSystem::copyFileTest
    Test::FileSystem::copyFileErrorTest
    Test::FileSystem::moveFileTest
    Test::FileSystem::moveFileErrorTest
    Test::FileSystem::syncFileTest
    Test::FileSystem::removeDirectoryTest
    Test::FileSystem::removeDirectoryErrorTest
    Test::FileSystem::cleanDirectoryTest
    Test::FileSystem::cleanDirectoryErrorTest
    Test::FileSystem::compressFileTest
    Test::FileSystem::compressFileErrorTest
    Test::FileSystem::findToRemoveTest
}
