# CrackerJack but Dockerized!

See https://github.com/ctxis/crackerjack for what this tool does, this repository only dockerizes it.

## Supported Drivers
As CrackerJack is built on top of Hashcat we need to install some drivers before we can make proper use of it.
The following drivers are already built into the container.

**CPU:**
 - [x] OpenCL (AMD / Intel)

**GPU:**
 - [x] CUDA (Nvidia)
 - [ ] AMD?

## Usage

This repository comes with a bare-minimum docker-compose.yml file to deploy it on your server, GPU support is currently not implemented.
