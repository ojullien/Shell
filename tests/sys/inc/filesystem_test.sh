## -----------------------------------------------------------------------------
## Linux Scripts.
## Test of the filesystem functions
##
## @package ojullien\Shell\tests
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Checks whether a directory exists
## -----------------------------------------------------------------------------

Test::FileSystem::checkDirTest() {
    FileSystem::checkDir "Directory exists:\t${m_DIR_REALPATH}" "${m_DIR_REALPATH}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::checkDirErrorTest() {
    FileSystem::checkDir "Directory does not exist:\t${m_DIR_REALPATH}/doesnotexist" "${m_DIR_REALPATH}/doesnotexist"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Checks whether a file exists
## -----------------------------------------------------------------------------

Test::FileSystem::checkFileTest() {
    FileSystem::checkFile "File exists:\t${m_TEST_DIR_SYS_CFG}/constant.cfg.sh" "${m_TEST_DIR_SYS_CFG}/constant.cfg.sh"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::checkFileErrorTest() {
    FileSystem::checkFile "File does not exist:\t${m_TEST_DIR_SYS_CFG}/doesnotexist.cfg.sh" "${m_TEST_DIR_SYS_CFG}/doesnotexist.cfg.sh"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY
## -----------------------------------------------------------------------------

Test::FileSystem::copyFileTest() {
    FileSystem::copyFile "${m_TEST_DIR_SYS_CFG}" "${m_TEST_DIR_SCRIPT}/log"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::copyFileErrorTest() {
    FileSystem::copyFile "${m_TEST_DIR_SYS_CFG}/doesnotexist" "${m_TEST_DIR_SCRIPT}/log"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Rename SOURCE to DEST, or move SOURCE(s) to DIRECTORY.
## -----------------------------------------------------------------------------

Test::FileSystem::moveFileTest() {
    FileSystem::moveFile "${m_TEST_DIR_SCRIPT}/log/cfg" "${m_TEST_DIR_SCRIPT}/log/delete_me"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::moveFileErrorTest() {
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
    FileSystem::removeDirectory "${m_TEST_DIR_SCRIPT}/log/delete_me"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::removeDirectoryErrorTest() {
    FileSystem::removeDirectory "${m_TEST_DIR_SCRIPT}/log/doesnotexist"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::cleanDirectoryTest() {
    local sDirPath="${m_TEST_DIR_SCRIPT}/log/delete_me"
    local sFile01Path="${m_TEST_DIR_SCRIPT}/log/delete_me/file01.txt"
    local sFile02Path="${m_TEST_DIR_SCRIPT}/log/delete_me/file02.txt"
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
    local sDirPath="${m_TEST_DIR_SCRIPT}/log/doesnotexist"
    FileSystem::cleanDirectory "${m_TEST_DIR_SCRIPT}/log/doesnotexist"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Compress
## -----------------------------------------------------------------------------

Test::FileSystem::compressFileTest() {
    local sDirPath="${m_TEST_DIR_SCRIPT}/log/compress_me"
    local sFile01Path="${m_TEST_DIR_SCRIPT}/log/compress_me/file01.txt"
    local sFile02Path="${m_TEST_DIR_SCRIPT}/log/compress_me/file02.txt"
    mkdir -p "${sDirPath}"
    touch "${sFile01Path}" "${sFile02Path}"
    FileSystem::compressFile "${m_TEST_DIR_SCRIPT}/log/compressed" "${sDirPath}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
    rm -Rf "${sDirPath}" "${m_TEST_DIR_SCRIPT}/log/compressed.tar.bz2"
}

Test::FileSystem::compressFileErrorTest() {
    FileSystem::compressFile "${m_TEST_DIR_SCRIPT}/log/empty" "${m_TEST_DIR_SCRIPT}/log/doesnotexist"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
    rm -f "${m_TEST_DIR_SCRIPT}/log/empty.tar.bz2"
}

## -----------------------------------------------------------------------------
## Find and remove files
## -----------------------------------------------------------------------------

Test::FileSystem::findToRemoveTest() {
    local sDirPath="${m_TEST_DIR_SCRIPT}/log/delete_me"
    local sFile01Path="${m_TEST_DIR_SCRIPT}/log/delete_me/file01.txt"
    local sFile02Path="${m_TEST_DIR_SCRIPT}/log/delete_me/file02.txt"
    mkdir -p "${sDirPath}"
    touch "${sFile01Path}" "${sFile02Path}"
    FileSystem::findToRemove "${m_TEST_DIR_SCRIPT}/log" "*.txt"
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
