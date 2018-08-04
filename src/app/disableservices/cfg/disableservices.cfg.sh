## -----------------------------------------------------
## Linux Scripts.
## Services App Configuration file.
##
## @category Linux Scripts
## @package Services
## @version 20180804
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

readonly m_SERVICES_DISABLE="bind9 exim4 postfix smbd nmbd telnet rlogin rexec ftp automount named lpd inetd"
readonly m_SERVICES_STOP="apache2 php7.2-fpm php7.1-fpm php7.0-fpm php5-fpm mysql fail2ban"
readonly m_SERVICES_START="mysql php7.2-fpm php7.1-fpm php7.0-fpm php5-fpm apache2 fail2ban"

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
String::separateLine
String::notice "App configuration: DisableServices"
String::notice "\tServices to disable:"
String::notice  "\t\t${m_SERVICES_DISABLE}"
String::notice "\tServices to stop:"
String::notice  "\t\t${m_SERVICES_STOP}"
String::notice "\tServices to start:"
String::notice  "\t\t${m_SERVICES_START}"
