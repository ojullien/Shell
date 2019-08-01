# Shell

Personal Shell scripting projects in bash. This package is a metapackage aggregating the following bash components (as submodules):

- Core framework
  - [sys](https://github.com/ojullien/bash-sys) contains scripts that offer useful functions.
- Applications
  - [autosave](https://github.com/ojullien/bash-autosave): Builds a timestamped compressed archive with system logs, web logs and send it to a ftp server.
  - [autosavedb](https://github.com/ojullien/bash-autosavedb): Builds a timestamped compressed archive with databases data, and send it to a ftp server.
  - [clean](https://github.com/ojullien/bash-clean): Cleans the /var/log folder.
  - [createdomain](https://github.com/ojullien/bash-createdomain): Creates an apache user/group and a home directory in /var/www.
  - [fillwithzeros](https://github.com/ojullien/bash-fillwithzeros): Fills disks with zero for compression (virtualization) and shutdown the server.
  - [install](https://github.com/ojullien/bash-install): Configures a fresh debian/ubuntu installation.
  - [manageservices](https://github.com/ojullien/bash-manageservices): Disable, start or stop a list of services defined in the config.sh file.
  - [pki](https://github.com/ojullien/bash-pki): Simple Public Key Infrastructure (PKI) management toolkit.
  - [savedb](https://github.com/ojullien/bash-savedb): Saves a database.
  - [savesite](https://github.com/ojullien/bash-savesite): Saves a www site (located in /var/www).
  - [savesystemconf](https://github.com/ojullien/bash-savesystemconf): Saves a system configuration (located in /etc).
  - [tartime](https://github.com/ojullien/bash-tartime): Tar and compress files to a timestamped bz2 archive. Standalone script located in bin folder.
  - [updatesystem](https://github.com/ojullien/bash-updatesystem): Updates the system.

*As I use these scripts for my own projects, they contain only the features I need.*

## Table of Contents

[Installation](#installation) | [Documentation](#documentation) | [Contributing](#contributing) | [License](#license)

## Installation

Require a Debian/Ubuntu version of linux and a Bash version ~4.4.

1. [Download a release](https://github.com/ojullien/Shell/releases) or clone this repository using this command: `git clone --recurse-submodules https://github.com/ojullien/Shell`.
2. Use [scripts/install.sh](https://github.com/ojullien/Shell/tree/master/scripts) to automatically install the project in the /opt/oju/bash folder.
3. If needed, add `PATH="$PATH:/opt/oju/bash/bin"` to the .profile files.
4. For each apps in `/opt/oju/bash/app` check out and edit the configuration file named `config.sh`.
5. Run the app you want. In `/opt/oju/bash/bin` folder run `./<app_name>.sh` or `bash <app_name>.sh`.

## Documentation

I wrote and I use these scripts for my own projects. And, unfortunately, I do not provide exhaustive documentation. Please read the code and the comments ;)

## Contributing

**Thanks you for taking the time to contribute**. If you wish to contribute, please read the [CONTRIBUTING](CONTRIBUTING.md) and [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md) files.

## License

This project is open-source and is licensed under the [MIT License](LICENSE).
