## -----------------------------------------------------------------------------
## Linux Scripts.
## File System functions
##
## @category Linux Scripts
## @package Includes
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Checks whether a directory exists
## -----------------------------------------------------------------------------

Test::FileSystem::checkDirTest() {
    FileSystem::checkDir "Directory exists:\t${m_DIR}" "${m_DIR}"
    FileSystem::checkDir "Directory does not exist:\t${m_DIR}/doesnotexist" "${m_DIR}/doesnotexist"
}

## -----------------------------------------------------------------------------
## Checks whether a file exists
## -----------------------------------------------------------------------------

Test::FileSystem::checkFileTest() {
    FileSystem::checkFile "File exists:\t${m_TEST_DIR_SYS_CFG}/constant.cfg.sh" "${m_TEST_DIR_SYS_CFG}/constant.cfg.sh"
    FileSystem::checkFile "File does not exist:\t${m_TEST_DIR_SYS_CFG}/doesnotexist.cfg.sh" "${m_TEST_DIR_SYS_CFG}/doesnotexist.cfg.sh"
}

## -----------------------------------------------------------------------------
## Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY
## -----------------------------------------------------------------------------

Test::FileSystem::copyFileTest() {
    FileSystem::copyFile "${m_TEST_DIR_SYS_CFG}" "${m_TEST_DIR_SCRIPT}/log"
    FileSystem::copyFile "${m_TEST_DIR_SYS_CFG}/doesnotexist" "${m_TEST_DIR_SCRIPT}/log"
}

## -----------------------------------------------------------------------------
## Rename SOURCE to DEST, or move SOURCE(s) to DIRECTORY.
## -----------------------------------------------------------------------------

Test::FileSystem::moveFileTest() {
    FileSystem::moveFile "${m_TEST_DIR_SCRIPT}/log/cfg" "${m_TEST_DIR_SCRIPT}/log/delete_me"
    FileSystem::moveFile "${m_TEST_DIR_SCRIPT}/log/doesnotexist" "${m_TEST_DIR_SCRIPT}/log/delete_me_too"
}

## -----------------------------------------------------------------------------
## Flush file system buffers
## -----------------------------------------------------------------------------

Test::FileSystem::syncFileTest() {
    FileSystem::syncFile
}

## -----------------------------------------------------------------------------
## Directories
## -----------------------------------------------------------------------------

Test::FileSystem::removeDirectoryTest() {
    FileSystem::removeDirectory "${m_TEST_DIR_SCRIPT}/log/delete_me"
    FileSystem::removeDirectory "${m_TEST_DIR_SCRIPT}/log/doesnotexist"
}

Test::FileSystem::cleanDirectoryTest() {
    local sDirPath="${m_TEST_DIR_SCRIPT}/log/delete_me"
    local sFile01Path="${m_TEST_DIR_SCRIPT}/log/delete_me/file01.txt"
    local sFile02Path="${m_TEST_DIR_SCRIPT}/log/delete_me/file02.txt"
    FileSystem::createDirectory "${sDirPath}"
    touch "${sFile01Path}" "${sFile02Path}"
    FileSystem::cleanDirectory "${sDirPath}"
    if [[ -f ${sFile01Path} ]] || [[ -f ${sFile02Path} ]]; then
        String:error "Test::FileSystem::cleanDirectoryTest failure."
    fi
    rm -Rf "${sDirPath}"
    FileSystem::cleanDirectory "${m_TEST_DIR_SCRIPT}/log/doesnotexist"
}
## -----------------------------------------------------------------------------
## Compress
## -----------------------------------------------------------------------------

Test::FileSystem::compressFileTest() {
    local sDirPath="${m_TEST_DIR_SCRIPT}/log/compress_me"
    local sFile01Path="${m_TEST_DIR_SCRIPT}/log/compress_me/file01.txt"
    local sFile02Path="${m_TEST_DIR_SCRIPT}/log/compress_me/file02.txt"
    FileSystem::createDirectory "${sDirPath}"
    touch "${sFile01Path}" "${sFile02Path}"
    FileSystem::compressFile "${m_TEST_DIR_SCRIPT}/log/compressed" "${sDirPath}"
    FileSystem::compressFile "${m_TEST_DIR_SCRIPT}/log/empty" "${m_TEST_DIR_SCRIPT}/log/doesnotexist"
    rm -Rf "${sDirPath}" "${m_TEST_DIR_SCRIPT}/log/compressed.tar.bz2" "${m_TEST_DIR_SCRIPT}/log/empty.tar.bz2"
}

## -----------------------------------------------------------------------------
## Find and remove files
## -----------------------------------------------------------------------------

Test::FileSystem::findToRemoveTest() {
    local sDirPath="${m_TEST_DIR_SCRIPT}/log/delete_me"
    local sFile01Path="${m_TEST_DIR_SCRIPT}/log/delete_me/file01.txt"
    local sFile02Path="${m_TEST_DIR_SCRIPT}/log/delete_me/file02.txt"
    FileSystem::createDirectory "${sDirPath}"
    touch "${sFile01Path}" "${sFile02Path}"
    FileSystem::findToRemove "${m_TEST_DIR_SCRIPT}/log" "*.txt"
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
    Test::FileSystem::checkFileTest
    # Keep the order
    Test::FileSystem::copyFileTest
    Test::FileSystem::moveFileTest
    Test::FileSystem::syncFileTest
    Test::FileSystem::removeDirectoryTest
    Test::FileSystem::cleanDirectoryTest
    Test::FileSystem::compressFileTest
    Test::FileSystem::findToRemoveTest
}
