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

Require a Debian/Ubuntu version of linux.

1. [Download a release](https://github.com/ojullien/Shell/releases) or clone this repository to install this project.
2. For each apps in app folder check out the configuration files located in app/\<app_name\>/cfg/.
   1. Rename \<app_name\>-sample.cnf to <app_name>.cnf
   2. Edit \<app_name\>.cnf
3. Run the app you want. In the Shell (root) folder run `./<app_name>.sh`

All the main app scripts can take the following options:

- `-d` Display mode. Contents are not displayed.
- `-l` Log mode. Contents are logged.
- `-w` Wait user. Wait for user input between actions.

## Features

- Core framework
  - [sys/cfg/](https://github.com/ojullien/Shell/blob/master/src/sys/cfg) contains main configuration files.
  - [sys/inc/](https://github.com/ojullien/Shell/blob/master/src/sys/inc) contains scripts that offer useful functions:
    - [apt.inc](https://github.com/ojullien/Shell/blob/master/src/sys/cfg/apt.inc): package manager (dpkg, apt, aptitude)
    - [filesystem.inc](https://github.com/ojullien/Shell/blob/master/src/sys/cfg/filesystem.inc): file system functions.
    - [option.inc](https://github.com/ojullien/Shell/blob/master/src/sys/cfg/option.inc): command line options functions.
    - [string.inc](https://github.com/ojullien/Shell/blob/master/src/sys/cfg/string.inc): string functions.
    - [service.inc](https://github.com/ojullien/Shell/blob/master/src/sys/cfg/service.inc): service manager (use systemV.inc or systemD.inc)
    - [systemD.inc](https://github.com/ojullien/Shell/blob/master/src/sys/cfg/systemD.inc): System V service manager.
    - [systemV.inc](https://github.com/ojullien/Shell/blob/master/src/sys/cfg/systemV.inc): systemd service manager.

- Applications
  - [app/](https://github.com/ojullien/Shell/blob/master/src/app) contains the main core files (functions, configurations, ...) for each apps.
  - [install.sh](https://github.com/ojullien/Shell/blob/master/src/install.sh) Configure a fresh debian/ubuntu installation. (ssh is already installed and configured)
    - Initial update and upgrade
      - update source.list,
      - update system
      - upgrade system
    - Install or modify bashrc files
    - Configure swap
    - Uninstall packages (vim-tiny, ...)
    - Install system packages (dkms, build-essential, util-linux, deborphan, localepurge, hdparm, smartmontools, ...)
    - Install and configure app packages (vim, fail2ban, ftp, mlocate, chkrootkit, logwatch, ...)
    - Optimize SSD
  - [autosave.sh](https://github.com/ojullien/Shell/blob/master/src/autosave.sh) Configure a fresh debian/ubuntu installation.

## Documentation

I wrote and I use these scripts for my own projects. And, unfortunately, I do not provide exhaustive documentation. Please read the code and the comments ;)

## Test

I do not provide any test at this time. Sorry.

## Contributing

Thanks you for taking the time to contribute. Please fork the repository and make changes as you'd like.

As I use these scripts for my own projects, it contains only the features I need. But If you have any ideas, just open an [issue](https://github.com/ojullien/Shell/issues/new) and tell me what you think. Pull requests are also warmly welcome.

If you encounter any **bugs**, please open an [issue](https://github.com/ojullien/Shell/issues/new).

Be sure to include a title and clear description,as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

## License

This project is open-source and is licensed under the [MIT License](https://github.com/ojullien/Shell/blob/master/LICENSE).
