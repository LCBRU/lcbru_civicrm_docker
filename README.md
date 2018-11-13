# CiviCRM Docker

Docker-Compose configuration for running CiviCRM, including
the BRC custom code.

## Development Installation

1. Download the code from github

```bash
git clone https://github.com/LCBRU/lcbru_civicrm_docker.git
```

2. Download the BRC custom code

Download the custom code respository: `lcbru_civicrm_custom` from GitHub

3. Link custom code

Link the custom code directory into this repository directory,
using the command:

```bash
ln -s {custom code directory} {docker directory}/lcbru_civicrm
```

4. Enviroment

Copy the file `example.env` to `.env`.  Change the value of
`ENBALED_PACKAGES` environment variable to a comma-separated
list of the modules that you want enabling.

## Building

To build the development instance, use the command:

```bash
docker-compose build
```

## Running

To run the development instance, use the command:

```bash
docker-compose up
```
