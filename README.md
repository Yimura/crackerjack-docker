# CrackerJack but Dockerized!

See https://github.com/ctxis/crackerjack for what this tool does, this repository only dockerizes it.

## Supported Drivers

The following hardware vendors are supported currently:

**CPU:**
 - [x] OpenCL (Intel)
 - [ ] OpenCL (AMD)

**GPU:**
 - [x] CUDA (Nvidia)
 - [ ] AMD?

## Usage

This repository comes with a bare-minimum docker-compose.yml file to deploy it on your server, GPU support is currently not implemented.

To run select the docker-compose file you want to have
- `docker-compose.cpu.yml` is only cpu support.
- `docker-compose.gpu.yml` is cpu and gpu supported.

If you want to use the prebuilt images, run the following command.
`docker compose -f <selected-profile> up -d --no-build`

If you want to build the image yourself.
`docker compose -f <selected-profile> up -d --build`

## Wordlists and Rules

This container comes with the [SecList](https://github.com/danielmiessler/SecLists) pre-installed and with the [OneRuleToRuleThemAll](https://github.com/NotSoSecure/password_cracking_rules.git) rule.
Masks are not present as of now.
