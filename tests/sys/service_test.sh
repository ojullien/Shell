## -----------------------------------------------------------------------------
## Linux Scripts.
## Test of service functions
##
## @package ojullien\Shell\tests\sys
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Stop
## -----------------------------------------------------------------------------

Test::Service::stopParameterTest() {
    Service::stop
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Service::stopUnknownServiceTest() {
    local sValueToTest="servicedoesnotexist"
    Service::stop "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::Service::stopTest() {
    local sValueToTest="ntp"
    Service::stop "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::Service::stopAgainTest() {
    local sValueToTest="ntp"
    Service::stop "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------

Test::Service::startParameterTest() {
    Service::start
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Service::startUnknownServiceTest() {
    local sValueToTest="servicedoesnotexist"
    Service::start "${sValueToTest}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Service::startTest() {
    local sValueToTest="ntp"
    Service::start "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::Service::startAgainTest() {
    local sValueToTest="ntp"
    Service::start "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Use lowerspace in namespace of the main function
## -----------------------------------------------------------------------------

Test::service::main() {
    String::separateLine
    String::notice "Testing: sys/Service ..."
    # shellcheck source=/dev/null
    . "${m_DIR_SYS}/runasroot.sh"
    Test::Service::stopParameterTest
    Test::Service::stopUnknownServiceTest
    Test::Service::stopTest
    Test::Service::stopAgainTest
    Test::Service::startParameterTest
    Test::Service::startUnknownServiceTest
    Test::Service::startTest
    Test::Service::startAgainTest
}
