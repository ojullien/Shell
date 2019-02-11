## -----------------------------------------------------------------------------
## Linux Scripts.
## Clean log app configuration file.
##
## @package ojullien\Shell\app\clean
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

# Files to delete in /var/log
readonly m_CLEAN_FILES="*.gz *.old *.1 *.2 *.log.*"
# Directories to clean in /var/log
readonly m_CLEAN_SPEC_DIR=("exim4" "apache2_evasive" "apache2" "php7.0" "php7.0" "mysql" "php5" "apt")
# Files to clean in /var/log/${m_CLEAN_SPEC_DIR[x]}
readonly m_CLEAN_SPEC_FILES=("*log.*" "dos-*" "*.log" "*.log" "*.slow" "*.log" "*.log" "*.log")
