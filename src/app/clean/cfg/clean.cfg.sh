## -----------------------------------------------------
## Linux Scripts.
## Clean App Configuration file.
##
## @category Linux Scripts
## @package Clean
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

readonly m_CLEAN_FILES="*.gz *.old *.1 *.2 *.log.*"
readonly m_CLEAN_SERVICES_DISABLE="bind9 postfix exim4 smbd nmbd telnet rlogin rexec ftp automount named lpd inetd"
readonly m_CLEAN_SERVICES_STOP="apache2 php7.2-fpm php7.1-fpm php7.0-fpm php5-fpm mysql fail2ban"
readonly m_CLEAN_SERVICES_START="mysql php7.2-fpm php7.1-fpm php7.0-fpm php5-fpm apache2 fail2ban"

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
String::separateLine
String::notice "App configuration: Clean"
String::notice "\tFiles to delete:"
String::notice  "\t\t${m_CLEAN_FILES}"
String::notice "\tServices to disable:"
String::notice  "\t\t${m_CLEAN_SERVICES_DISABLE}"
String::notice "\tServices to stop:"
String::notice  "\t\t${m_CLEAN_SERVICES_STOP}"
String::notice "\tServices to start:"
String::notice  "\t\t${m_CLEAN_SERVICES_START}"
