# Makefile for Docker Swarm deployment

COMPOSE_FILE := srcs/docker-compose.yml
ENV_FILE := srcs/.env
PROJECT_NAME := inception

.PHONY: build up down start stop re logs ps prune swarm-init swarm-leave swarm-status

# ------------------------------------------------------------------------------
# Docker Swarm Management
# ------------------------------------------------------------------------------

swarm-init:
	@docker swarm init 2>/dev/null || echo "Swarm already initialized ✅"

swarm-leave:
	@docker swarm leave --force || true

swarm-status:
	@docker info | grep "Swarm"

# ------------------------------------------------------------------------------
# Stack (Swarm) Commands
# ------------------------------------------------------------------------------

# Deploys the entire stack with secrets via Swarm
up: swarm-init
	@echo "🚀 Loading environment variables from .env..."
	set -a; . srcs/.env; set +a; \
	echo "🚀 Deploying stack '$(PROJECT_NAME)'..."; \
	docker stack deploy -c $(COMPOSE_FILE) $(PROJECT_NAME)

down:
	@echo "🧹 Removing stack '$(PROJECT_NAME)'..."
	docker stack rm $(PROJECT_NAME)
	@echo "⏳ Waiting for cleanup..."
	sleep 5
	@docker system prune -f --volumes

# Builds the local images with compose
build:
	@echo "🔨 Building custom images..."
	docker build -t inception_nginx ./srcs/requirements/nginx
	docker build -t inception_mariadb ./srcs/requirements/mariadb
	docker build -t inception_wordpress ./srcs/requirements/wordpress

logs:
	docker service logs -f $(PROJECT_NAME) logs -f

ps:
	docker stack ps $(PROJECT_NAME)

# Cleans everything (images, volumes, networks)
prune:
	@echo "🧽 Cleaning Docker system..."
	docker system prune -af --volumes

re: down build up
	@echo "🔁 Stack rebuilt and redeployed successfully ✅"

# make build   # builds all images from srcs/requirements/*
# make up      # deploys using srcs/docker-compose.yml
# make ps      # check running stack services
# make down    # remove everything