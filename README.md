# Shell

Personal Shell scripting projects.

## Table of Contents

- [Installation](#installation)
- [Features](#features)
- [Documentation](#documentation)
- [Test](#test)
- [Contributing](#contributing)
- [License](#license)

## Installation

Require a Debian/Ubuntu version of linux and a Bash version ~4.4.

1. [Download a release](https://github.com/ojullien/Shell/releases) or clone this repository to install this project.
2. For each apps in app folder check out and edit the configuration files located in app/\<app_name\>/cfg/.
3. Run the app you want. In the Shell (root) folder run `./<app_name>.sh`

All the main app scripts can take the following options:

- `-n | --no-display` Display mode. Contents are not displayed.
- `-l | --active-log` Log mode. Contents are logged.
- `-w | --wait` Wait user. Wait for user input between actions.

## Features

- Core framework
  - [sys/cfg/](https://github.com/ojullien/Shell/blob/master/src/sys/cfg) contains main configuration files.
  - [sys/inc/](https://github.com/ojullien/Shell/blob/master/src/sys/inc) contains scripts that offer useful functions:
    - apt.inc.sh: package manager (dpkg, apt, aptitude)
    - filesystem.inc.sh: file system functions.
    - ftp.inc.sh: FTP functions.
    - mariadb.inc.sh: MariaDB functions.
    - mysql.inc.sh: MySQL functions.
    - option.inc.sh: command line options functions.
    - string.inc.sh: string functions.
    - service.inc.sh: service manager (use systemV.inc.sh or systemD.inc.sh)
    - systemD.inc.sh: System V service manager.
    - systemV.inc.sh: systemd service manager.

- Applications
  - [app/](https://github.com/ojullien/Shell/blob/master/src/app) contains the main core files (functions, configurations, ...) for each apps.
  - autosave.sh: Builds a timestamped compressed archive with system logs, web logs and send it to a ftp server. Clean the system log after that.
  - autosavedb.sh: Builds a timestamped compressed archive with databases data, and send it to a ftp server.
  - clean.sh: Cleans the /var/log folder.
  - createdomain.sh: Creates an apache user/group and a home directory in /var/www.
  - disableservices.sh: Disables unwanted services.
  - fillwithzeros.sh: Fills disks with zero for compression (virtualization) and shutdown the server.
  - install.sh: Configures a fresh debian/ubuntu installation. (ssh is already installed and configured)
    - Initial update and upgrade
      - update source.list
      - update system
      - upgrade system
    - Install or modify bashrc files
    - Configure swap
    - Uninstall packages (vim-tiny, ...)
    - Install system packages (dkms, build-essential, util-linux, deborphan, localepurge, hdparm, smartmontools, ...)
    - Install and configure app packages (vim, fail2ban, ftp, mlocate, chkrootkit, logwatch, ...)
    - Optimize SSD
  - savedb.sh: Saves a database.
  - savesite.sh: Saves a www site (located in /var/www).
  - savesystemconf.sh: Saves a system configuration (located in /etc).
  - tartime.sh: Tar and compress files to a timestamped bz2 archive. Standalone script.
  - update-system.sh: Updates the system.

## Documentation

I wrote and I use these scripts for my own projects. And, unfortunately, I do not provide exhaustive documentation. Please read the code and the comments ;)

## Test

I wrote few lines of 'unit test' code for the core framework (sys). No more, sorry.

## Contributing

Thanks you for taking the time to contribute. Please fork the repository and make changes as you'd like.

As I use these scripts for my own projects, it contains only the features I need. But If you have any ideas, just open an [issue](https://github.com/ojullien/Shell/issues/new) and tell me what you think. Pull requests are also warmly welcome.

If you encounter any **bugs**, please open an [issue](https://github.com/ojullien/Shell/issues/new).

Be sure to include a title and clear description,as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

## License

This project is open-source and is licensed under the [MIT License](https://github.com/ojullien/Shell/blob/master/LICENSE).
