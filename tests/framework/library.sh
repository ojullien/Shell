## -----------------------------------------------------------------------------
## Linux Scripts.
## Test functions
##
## @package ojullien\Shell\tests
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

Test::assertTrue() {
    if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: assertTrue <FUNCTION NAME> <RETURN VALUE>"
        exit 1
    fi
    local sFunctionName="$1"
    local -i iReturnValue="$2"
    if ((0==iReturnValue)); then
        String::success "Test of ${sFunctionName}: success."
    else
        String::error "Test of ${sFunctionName}: failure."
    fi
}

Test::assertFalse() {
    if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: assertFalse <FUNCTION NAME> <RETURN VALUE>"
        exit 1
    fi
    local sFunctionName="$1"
    local -i iReturnValue="$2"
    if ((0!=iReturnValue)); then
        String::success "Test of ${sFunctionName}: success."
    else
        String::error "Test of ${sFunctionName}: failure."
    fi
}
