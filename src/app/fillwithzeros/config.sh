## -----------------------------------------------------------------------------
## Linux Scripts.
## fillWithZeros app configuration file.
##
## @package ojullien\Shell\app\fillwithzeros
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

readonly m_ZEROFILE="zerofile"
declare -a m_HARDDISKS
mapfile -t m_HARDDISKS < <(lsblk --noheadings --nodeps --list --output NAME | grep "sd")

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
FillWithZeros::trace() {
    String::separateLine
    String::notice "App configuration: FillWithZeros"
    String::notice "\tHard disks:"
    String::notice "\t\t${m_HARDDISKS}"
    return 0
}
