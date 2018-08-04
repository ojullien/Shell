## -----------------------------------------------------
## Linux Scripts.
## String functions
##
## @category Linux Scripts
## @package Includes
## @version 20180804
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

Test::Log::writeToLogTest() {
    Log::writeToLog "Hello log file"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::Console::displayErrorTest() {
    Console::displayError -n "This is an error message "
    Console::displayError " sent to the console."
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::Console::displaySuccessTest() {
    Console::displaySuccess -n "This is a success message "
    Console::displaySuccess " sent to the console."
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::Console::displayTest() {
    Console::display -n "This is a notice message "
    Console::display " sent to the console."
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::String::errorTest() {
    String::error -n "This is an error message "
    String::error " sent to the console and the log file."
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::String::noticeTest() {
    String::notice -n "This is a notice message "
    String::error " sent to the console and the log file."
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::String::successTest() {
    String::success -n "This is a notice success "
    String::error " sent to the console and the log file."
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::String::separateLineTest() {
    String::separateLine
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------
##
## -----------------------------------------------------

Test::String::main() {
    Test::String::separateLineTest
    String::notice "Testing: sys/string ..."

    Test::Log::writeToLogTest
    Test::Console::displayErrorTest
    Test::Console::displaySuccessTest
    Test::Console::displayTest
    Test::String::errorTest
    Test::String::noticeTest
    Test::String::successTest

    Test::String::separateLineTest

}
