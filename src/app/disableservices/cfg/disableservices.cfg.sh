## -----------------------------------------------------
## Linux Scripts.
## Stop Services App Configuration file.
##
## @category  Linux Scripts
## @package   Services
## @version   20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

m_SERVICES_DISABLE="bind9 exim4 postfix smbd nmbd telnet rlogin rexec ftp automount named lpd inetd"

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
String::separateLine
String::notice "App configuration: DisableServices"
String::notice "\tServices to disable:"
String::notice  "\t\t${m_SERVICES_DISABLE}"
