## -----------------------------------------------------
## Linux Scripts.
## String functions
##
## @category Linux Scripts
## @package Includes
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

Test::Log::writeToLogTest() {
    Log::writeToLog "Hello log file"
}

Test::Console::displayErrorTest() {
    Console::displayError "This is an error message sent to the console."
}

Test::Console::displaySuccessTest() {
    Console::displaySuccess "This is a success message sent to the console."
}

Test::Console::displayTest() {
    Console::display "This is a notice message sent to the console."
}

Test::String::errorTest() {
    String::error "This is an error message sent to the console and the log file."
}

Test::String::noticeTest() {
    String::notice "This is a notice message sent to the console and the log file."
}

Test::String::successTest() {
    String::success "This is a notice success sent to the console and the log file."
}

Test::String::separateLineTest() {
    String::separateLine
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
