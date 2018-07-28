## -----------------------------------------------------
## Linux Scripts.
## Clean App Configuration file.
##
## @category  Linux Scripts
## @package   Clean
## @version   20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

m_CLEAN_FILES="*.gz *.old *.1 *.2 *.log.*"
m_CLEAN_SERVICES_DISABLE="bind9 postfix exim4 smbd nmbd telnet rlogin rexec ftp automount named lpd inetd"
m_CLEAN_SERVICES_STOP="apache2 php7.2-fpm php7.1-fpm php7.0-fpm php5-fpm mysql fail2ban"
m_CLEAN_SERVICES_START="mysql php7.2-fpm php7.1-fpm php7.0-fpm php5-fpm apache2 fail2ban"

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
separateLine
notice "App configuration: Clean"
notice "\tFiles to delete:"
notice  "\t\t${m_CLEAN_FILES}"
notice "\tServices to disable:"
notice  "\t\t${m_CLEAN_SERVICES_DISABLE}"
notice "\tServices to stop:"
notice  "\t\t${m_CLEAN_SERVICES_STOP}"
notice "\tServices to start:"
notice  "\t\t${m_CLEAN_SERVICES_START}"
