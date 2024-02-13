.DEFAULT_GOAL:=help

# Credits: https://github.com/sherifabdlnaby/elastdocker/

# This for future release of Compose that will use Docker Buildkit, which is much efficient.
COMPOSE_PREFIX_CMD := COMPOSE_DOCKER_CLI_BUILD=1

COMPOSE_INTEL_LOCAL := -f docker-compose.local.yml
COMPOSE_INTEL_NVIDIA_LOCAL := -f docker-compose.nvidia.local.yml
COMPOSE_INTEL := -f docker-compose.yml
COMPOSE_INTEL_NVIDIA := -f docker-compose.nvidia.yml

# --------------------------

.PHONY: up build prepopulate pull down stop restart rm logs test-nvidia-gpu

setup:			# Setup the crackerjack instance and prepopulate the DB.
	@make build && make up && make prepopulate

up:				## Build and start all services.
	docker-compose ${COMPOSE_ALL_FILES} up -d --build

build:			## Build all services.
	docker-compose ${COMPOSE_ALL_FILES} build

prepopulate:		## Run GPU tests.
	docker-compose $(COMPOSE_ALL_FILES) exec crackerjack-docker-crackerjack-1 nvidia-smi

pull:			## Pull Docker images.
	docker login docker.pkg.github.com
	docker-compose ${COMPOSE_ALL_FILES} pull

down:			## Down all services.
	docker-compose ${COMPOSE_INTEL_NVIDIA_LOCAL} down

stop:			## Stop all services.
	docker-compose ${COMPOSE_ALL_FILES} stop

restart:		## Restart all services.
	docker-compose ${COMPOSE_ALL_FILES} restart

rm:				## Remove all services containers.
	docker-compose $(COMPOSE_ALL_FILES) rm -f

test-nvidia-gpu:		## Run GPU tests.
	docker-compose $(COMPOSE_ALL_FILES) exec crackerjack-docker-crackerjack-1 nvidia-smi

logs:			## Tail all logs with -n 1000.
	docker-compose $(COMPOSE_ALL_FILES) logs --follow --tail=1000

images:			## Show all Docker images.
	docker-compose $(COMPOSE_ALL_FILES) images

prune:			## Remove containers and delete volume data.
	@make stop && make rm && docker volume prune -f

help:			## Show this help.
	@echo "Make application docker images and manage containers using docker-compose files."
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m (default: help)\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
