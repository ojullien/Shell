# Contributing

**Thanks you for taking the time to contribute!**

This package is a meta-package, aggregating the following bash components (as submodules):

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

The issues and pull requests rightfully belong against the individual components and **should be made** accordingly.

As we use these scripts for our own projects, they contain only the features we need. But, we want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug.
- Discussing the current state of the code.
- Submitting a fix.
- Proposing new features.
- Becoming a maintainer.

## We develop with GitHub

We use github to host code, to track issues and feature requests, as well as accept pull requests.

## If you have any ideas

Pull requests are the best way to propose changes to the codebase. There are warmly welcome.

## Bug and fix

If you encounter any **bugs**, please open an issue rightfully belong against the individual components.

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can.
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

## License

By contributing, you agree that your contributions will be licensed under its [MIT License](LICENSE).
