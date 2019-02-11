## -----------------------------------------------------------------------------
## Linux Scripts.
## DisableServices app configuration file.
##
## @package ojullien\Shell\app\manageservices
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

readonly m_SERVICES_DISABLE="bind9 exim4 postfix smbd nmbd telnet rlogin rexec ftp automount named lpd inetd"
readonly m_SERVICES_STOP="apache2 fail2ban php7.3-fpm php7.2-fpm php5-fpm mysql"
readonly m_SERVICES_START="mysql php7.3-fpm php7.2-fpm php5-fpm apache2 fail2ban"
