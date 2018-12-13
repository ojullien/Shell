#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## Run tests
##
## @package ojullien\Shell\Tests
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------

## -----------------------------------------------------------------------------
## Load constants
## -----------------------------------------------------------------------------
. "./sys/constant.sh"

## -----------------------------------------------------------------------------
## Includes sources
## -----------------------------------------------------------------------------
. "${m_DIR_SYS}/string.sh"
. "${m_DIR_SYS}/filesystem.sh"
. "${m_DIR_SYS}/option.sh"
. "${m_TEST_DIR_SYS}/test.sh"

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
Test::Constant::trace

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
