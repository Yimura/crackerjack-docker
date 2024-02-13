@echo off

:: Credits: https://github.com/ninjhacks

set COMPOSE_PREFIX_CMD = COMPOSE_DOCKER_CLI_BUILD=1

set COMPOSE_INTEL_LOCAL=-f docker-compose.intel.local.yml
set COMPOSE_AMD_LOCAL=-f docker-compose.amd.local.yml
set COMPOSE_INTEL_NVIDIA_LOCAL=-f docker-compose.nvidia.local.yml
set COMPOSE_INTEL=-f docker-compose.yml
set COMPOSE_INTEL_NVIDIA=-f docker-compose.nvidia.yml

set SELECTED_PROFILE=%COMPOSE_INTEL%

if "%2" == "local" (
    if "%3" == "intel" (
        set SELECTED_PROFILE=%COMPOSE_INTEL_LOCAL%
        if "%4" == "nvidia" (
            set SELECTED_PROFILE=%COMPOSE_INTEL_NVIDIA_LOCAL%
        )
    ) else (
        set SELECTED_PROFILE=%COMPOSE_AMD_LOCAL%
        if "%4" == "nvidia" (
            set SELECTED_PROFILE=%COMPOSE_AMD_NVIDIA_LOCAL%
        )
    )
)

if "%2" == "intel" (
    if "%3" == "nvidia" (
        set SELECTED_PROFILE=%COMPOSE_INTEL_NVIDIA_LOCAL%
    )
)
if "%2" == "amd" (
    set SELECTED_PROFILE=%COMPOSE_AMD_LOCAL%
    if "%3" == "nvidia" (
        set SELECTED_PROFILE=%COMPOSE_AMD_NVIDIA_LOCAL%
    )
)


@echo test %SELECTED_PROFILE%

:: Generate certificates.
if "%1" == "setup" call:setup
:: Build and start all services.
if "%1" == "up" call:up
:: Build all services.
if "%1" == "build" call:build
:: Generate Username (Use only after make up).
if "%1" == "prepopulate" call:prepopulate
:: Pull Docker images.
if "%1" == "pull" call:pull
:: Down all services.
if "%1" == "down" call:down
:: Stop all services.
if "%1" == "stop" call:stop
:: Restart all services.
if "%1" == "restart" call:restart
:: Check for the available devices to use with hashcat.
if "%1" == "check-available-devices" call:check-available-devices
:: Remove all services containers.
if "%1" == "rm" call:rm
:: Tail all logs with -n 1000.
if "%1" == "logs" call:logs
:: Show all Docker images.
if "%1" == "images" call:images
:: Remove containers and delete volume data.
if "%1" == "prune" call:prune
:: Show this help.
if "%1" == "help" (
    @echo To use the application, run the following commands:
    make {setup|up|build|prepopulate|pull|down|stop|restart|check-available-devices|rm|logs|images|prune}
)

EXIT /B 1

:setup
call:build & call:up & call:prepopulate
EXIT /B 0

:up
docker-compose %SELECTED_PROFILE% up -d --build
EXIT /B 0

:build
docker-compose %SELECTED_PROFILE% build --build-arg ADD_WORDLIST_N_RULES="true"
EXIT /B 0

:prepopulate
docker-compose %SELECTED_PROFILE% exec crackerjack ls
EXIT /B 0

:pull
docker login docker.pkg.github.com & docker-compose %SELECTED_PROFILE% pull
EXIT /B 0

:down
docker-compose %SELECTED_PROFILE% down
EXIT /B 0

:stop
docker-compose %SELECTED_PROFILE% stop %SERVICES%
EXIT /B 0

:restart
docker-compose %SELECTED_PROFILE% restart %SERVICES%
EXIT /B 0

:check-available-devices
docker-compose %SELECTED_PROFILE% exec crackerjack-docker-crackerjack-1 hashcat -I
EXIT /B 0

:rm
docker-compose %SELECTED_PROFILE% rm -f %SERVICES%
EXIT /B 0

:logs
docker-compose %SELECTED_PROFILE% logs --follow --tail=1000 %SERVICES%
EXIT /B 0

:images
docker-compose %SELECTED_PROFILE% images %SERVICES%
EXIT /B 0

:prune
call:stop & call:rm & docker volume prune -f
EXIT /B 0