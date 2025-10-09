# vstuen-pyscripts

*vstuen-pyscripts* is a collection of Python utility scripts packaged as a single, easy-to-install Python module. This package provides several command-line tools to manipulate text, handle dates, generate passwords, and more.


## Features

The package provides the following console scripts:

- **camelcase**: Converts input strings into camelCase.
- **capitalize**: Capitalizes input text.
- **isodate**: A utility to handle ISO8601 date and time strings
- **mwpwd**: A tool to handle hashes in MW (BCRYPT V2A)
- **pwdgen**: Generates passwords.
- **timerequest**: Simple wrapper to time http requests for a list of URL's
- **urldecode**: Decodes URL-encoded strings.
- **urlencode**: Encodes strings for safe URL usage.
- **urlq**: A URL query utility.
- **wftime**: A tool for registering WF hours

## Installation

This package is built using [Nix](https://nixos.org/), which makes it easy to reproduce builds and development environments.

### Building the Package

To build the package, run:

```bash
nix build
```

This command creates a result symlink pointing to the built package in the Nix store.

## Running a Script
For example, to run the camelcase command:
```bash
./result/bin/camelcase "your text here"
```

## Development Shell
```bash
nix develop
```
This shell is ideal for testing or further development.

## Structure
```bash
.
├── flake.lock          # Nix flake lock file.
├── flake.nix           # Nix flake file to build the package and dev shell.
├── setup.cfg           # Setuptools configuration (includes egg_info settings).
├── setup.py            # Setup script for the Python package.
└── src
    └── vstuen_pyscripts
        ├── __init__.py
        ├── camelcase.py
        ├── capitalize.py
        ├── isodate.py         
        ├── mwpwd.py
        ├── pwdgen.py
        ├── timerequest.py
        ├── urldecode.py
        ├── urlencode.py
        ├── urlq.py
        └── wftime.py
```