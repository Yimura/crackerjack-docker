# CrackerJack but Dockerized!

See https://github.com/ctxis/crackerjack for what this tool does, this repository only dockerizes it.

## Supported Drivers
As CrackerJack is built on top of Hashcat we need to install some drivers before we can make proper use of it.
The following drivers are already built into the container.

**CPU:**
 - [x] OpenCL (AMD / Intel)

**GPU:**
 - [ ] CUDA (Nvidia)
 - [ ] AMD?

## Usage

This repository comes with a bare-minimum docker-compose.yml file to deploy it on your server, GPU support is currently not implemented.

## Wordlists and Rules

This container comes with the [SecList](https://github.com/danielmiessler/SecLists) pre-installed and with the [OneRuleToRuleThemAll](https://github.com/NotSoSecure/password_cracking_rules.git) rule.
Masks are not present as of now.
