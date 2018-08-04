#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## Tests
##
## @category  Linux Scripts
## @package   Scripts
## @version   20180804
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Load constants
## -----------------------------------------------------------------------------
. "./sys/cfg/constant.cfg.sh"

## -----------------------------------------------------------------------------
## Includes sources
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_INC}/string.inc.sh"
. "${m_DIR_SYS_INC}/filesystem.inc.sh"
. "${m_DIR_SYS_INC}/option.inc.sh"

## -----------------------------------------------------------------------------
## Load configuration
## -----------------------------------------------------------------------------
. "${m_TEST_DIR_SYS_CFG}/main.cfg.sh"
#. "${m_TEST_DIR_SYS_CFG}/root.cfg.sh"

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename $0) process is: $$"
Console::waitUser

. "${m_TEST_DIR_SYS_INC}/string_test.inc.sh"
Test::String::main
Console::waitUser

. "${m_TEST_DIR_SYS_INC}/filesystem_test.inc.sh"
Test::FileSystem::main
Console::waitUser


## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
