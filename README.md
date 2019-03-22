# Shell

Personal Shell scripting projects.

## Table of Contents

[Installation](#installation) | [Features](#features) | [Documentation](#documentation) | [Test](#test) | [Contributing](#contributing) | [License](#license)

## Installation

Require a Debian/Ubuntu version of linux and a Bash version ~4.4.

1. [Download a release](https://github.com/ojullien/Shell/releases) or clone this repository.
2. Use [scripts/installShell.sh](https://github.com/ojullien/Shell/tree/master/scripts) to automatically install the project in the /opt/ folder.
3. If needed, add `PATH="$PATH:/opt/oju/Shell/bin"` to the .profile files.
4. For each apps in [app folder](https://github.com/ojullien/Shell/tree/master/src/app) check out and edit the configuration file named `config.sh`.
5. Run the app you want. In [Shell/bin](https://github.com/ojullien/Shell/tree/master/src/bin) folder run `./<app_name>.sh` or `bash <app_name>.sh`.

All the main app scripts can take, at least, the following options:

- `-n | --no-display` Display mode. Contents are not displayed.
- `-l | --active-log` Log mode. Contents are logged.
- `-w | --wait` Wait user. Wait for user input between actions.
- `-h | --help` Show the help..
- `-v | --version` Show the version.

## Features

- Core framework
  - [sys](https://github.com/ojullien/Shell/tree/master/src/sys) contains scripts that offer useful functions:
    - db/mariadb.sh: MariaDB functions.
    - db/mysql.sh: MySQL functions.
    - bashversion.sh: Tests the current bash version.
    - config.sh: Load local app configuration file.
    - constant.sh: Core constants.
    - filesystem.sh: file system functions.
    - ftp.sh: FTP functions.
    - option.sh: common command line options functions.
    - package.sh: package manager (dpkg, apt, aptitude)
    - runasroot.sh: Tests the user credentials.
    - service.sh: service manager (use system/d.sh or system/v.sh)
    - string.sh: string functions.
    - system/d.sh: System V service manager.
    - system/v.sh: systemd service manager.

- Applications
  - [app/](https://github.com/ojullien/Shell/tree/master/src/app) contains the main core files (functions, configurations, ...) for each apps.
  - autosave: Builds a timestamped compressed archive with system logs, web logs and send it to a ftp server. Clean the system log after that.
  - autosavedb: Builds a timestamped compressed archive with databases data, and send it to a ftp server.
  - clean: Cleans the /var/log folder.
  - createdomain: Creates an apache user/group and a home directory in /var/www.
  - fillwithzeros: Fills disks with zero for compression (virtualization) and shutdown the server.
  - install: Configures a fresh debian/ubuntu installation. (ssh is already installed and configured)
    - Initial update and upgrade
      - update source.list
      - update system
      - upgrade system
    - Install or modify .bashrc, .bash_alias, .profile files
    - Configure swap
    - Uninstall packages (vim-tiny, ...)
    - Install system packages (dkms, build-essential, util-linux, deborphan, localepurge, hdparm, smartmontools, ...)
    - Install and configure app packages (vim, fail2ban, ftp, mlocate, chkrootkit, logwatch, ...)
    - Optimize SSD
  - manageservices: Disable, start or stop a list of services defined in the config.sh file.
  - savedb: Saves a database.
  - savesite: Saves a www site (located in /var/www).
  - savesystemconf: Saves a system configuration (located in /etc).
  - tartime: Tar and compress files to a timestamped bz2 archive. Standalone script located in bin folder.
  - update-system: Updates the system.

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
