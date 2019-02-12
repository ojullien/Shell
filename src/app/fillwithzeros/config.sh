## -----------------------------------------------------------------------------
## Linux Scripts.
## fillWithZeros app configuration file.
##
## @package ojullien\Shell\app\fillwithzeros
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

readonly m_ZEROFILE="zerofile"

declare sDisk="" sMount=""
declare -g -a m_HARDDISKS=() m_MOUNTPOINTS=()

mapfile -t m_HARDDISKS < <(lsblk --noheadings --nodeps --list --output NAME | grep "sd")
for sDisk in "${m_HARDDISKS[@]}"; do
    sMount=$(findmnt --noheadings --output TARGET "/dev/${sDisk}1")
    if [[ -n ${sMount} ]]; then
        m_MOUNTPOINTS+=("${sMount}")
    fi
done

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
FillWithZeros::trace() {
    String::separateLine
    String::notice "App configuration: FillWithZeros"
    String::notice "\tHard disks:"
    String::notice "\t\t${m_HARDDISKS[@]}"
    String::notice "\tMount points:"
    String::notice "\t\t${m_MOUNTPOINTS[@]}"
    return 0
}
