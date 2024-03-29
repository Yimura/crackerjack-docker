@echo off

:: Credits: https://github.com/ninjhacks

set COMPOSE_PREFIX_CMD = COMPOSE_DOCKER_CLI_BUILD=1

set COMPOSE_CPU=crackerjack-cpu
set COMPOSE_GPU=crackerjack-gpu

set SELECTED_LOCAL=--no-build --pull always

set SELECTED_PROFILE=%COMPOSE_CPU%

if "%2" == "local" (
    set SELECTED_LOCAL=--build --pull never
    if "%3" == "gpu" (
        set SELECTED_PROFILE=%COMPOSE_GPU%
    )
)
if "%2" == "gpu" (
    set SELECTED_PROFILE=%COMPOSE_GPU%
)

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
    @echo make {setup,up,build,prepopulate,pull,down,stop,restart,check-available-devices,rm,logs,images,prune} {local or nothing} {gpu or nothing}
    @echo Example: make up local gpu
    @echo Example: make up local
    @echo Example: make up
    @echo Example: make up gpu
)

EXIT /B 1

:setup
call:build & call:up & call:prepopulate
EXIT /B 0

:up
docker-compose up -d %SELECTED_LOCAL% %SELECTED_PROFILE%
EXIT /B 0

:build
docker-compose build --build-arg ADD_WORDLIST_N_RULES="true" %SELECTED_PROFILE%
EXIT /B 0

:prepopulate
docker-compose exec %SELECTED_PROFILE% ls
EXIT /B 0

:pull
docker login docker.pkg.github.com & docker-compose pull %SELECTED_PROFILE%
EXIT /B 0

:down
docker-compose down %SELECTED_PROFILE%
EXIT /B 0

:stop
docker-compose stop %SELECTED_PROFILE%
EXIT /B 0

:restart
docker-compose restart %SELECTED_PROFILE%
EXIT /B 0

:check-available-devices
docker-compose exec %SELECTED_PROFILE% hashcat -I
EXIT /B 0

:rm
docker-compose rm -f %SELECTED_PROFILE%
EXIT /B 0

:logs
docker-compose logs --follow --tail=1000 %SELECTED_PROFILE%
EXIT /B 0

:images
docker-compose images %SELECTED_PROFILE%
EXIT /B 0

:prune
call:stop & call:rm & docker volume prune -f
EXIT /B 0
