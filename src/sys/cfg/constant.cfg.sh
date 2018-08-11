## -----------------------------------------------------
## Linux Scripts.
## Constants
##
## @category Linux Scripts
## @package Configuration
## @version 20180811
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

## -----------------------------------------------------
## Date
## -----------------------------------------------------
readonly m_DATE="$(date +"%Y%m%d")_$(date +"%H%M")"

## -----------------------------------------------------
## Main directories
## -----------------------------------------------------

# Directory holds scripts
readonly m_DIR_SCRIPT="$(pwd)"
# Working directory
readonly m_DIR="$(dirname "${m_DIR_SCRIPT}")"
# Directory holds system files
readonly m_DIR_SYS="${m_DIR_SCRIPT}/sys"
# Directory holds configuration system files
readonly m_DIR_SYS_CFG="${m_DIR_SYS}/cfg"
# Directory holds include system files
readonly m_DIR_SYS_INC="${m_DIR_SYS}/inc"
# Directory holds app files
readonly m_DIR_APP="${m_DIR_SCRIPT}/app"

## -----------------------------------------------------
## Main Files
## -----------------------------------------------------
readonly m_LOGFILE="${m_DIR_SCRIPT}/log/${m_DATE}_$(basename "$0").log"
