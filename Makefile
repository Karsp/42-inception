# Makefile for Docker Swarm deployment

COMPOSE_FILE := srcs/docker-compose.yml
ENV_FILE := srcs/.env
PROJECT_NAME := inception

.PHONY: make build up down start stop re logs ps prune swarm-init swarm-leave swarm-status clean fclean

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
up: swarm-init setup
	@echo "🚀 Loading environment variables from .env..."
	set -a; . $(ENV_FILE); set +a; \
	echo "🚀 Deploying stack '$(PROJECT_NAME)'..."; \
	docker stack deploy -c $(COMPOSE_FILE) $(PROJECT_NAME)

down:
	@echo "🧹 Removing stack '$(PROJECT_NAME)'..."
	docker stack rm $(PROJECT_NAME)
	@echo "⏳ Waiting for cleanup..."
	sleep 5

# Builds the local images with compose
build:
	@echo "🔨 Building custom images..."
	docker build -t inception_nginx ./srcs/requirements/nginx
	docker build -t inception_mariadb ./srcs/requirements/mariadb
	docker build -t inception_wordpress ./srcs/requirements/wordpress
	docker build -t inception_redis ./srcs/requirements/redis
	docker build -t inception_static_site ./srcs/requirements/static_site
	docker build -t inception_adminer ./srcs/requirements/adminer
	docker build -t inception_portainer ./srcs/requirements/portainer

make: build up

# ------------------------------------------------------------------------------
# Local Data Setup 
# ------------------------------------------------------------------------------

setup:
	@echo "📁 Setting up local volume directories..."
	@set -a; . $(ENV_FILE); set +a; \
	mkdir -p $${DB_DATA_DIR} $${WP_DATA_DIR} $${REDIS_DATA_DIR} $${PORTAINER_DATA_DIR}; \
	echo "✅ Directories created at:"; \
	echo "   - $$DB_DATA_DIR"; \
	echo "   - $$WP_DATA_DIR"; \
	echo "   - $$REDIS_DATA_DIR"; \
	echo "   - $$PORTAINER_DATA_DIR"


# ------------------------------------------------------------------------------
# Cleaning Targets
# ------------------------------------------------------------------------------

clean:
	@echo "🧹 Cleaning Docker resources (containers, networks, and volumes)..."
	@docker stack rm $(PROJECT_NAME) 2>/dev/null || true
	@sleep 5
	@docker network prune -f
	@docker volume prune -f
	@docker container prune -f
	@echo "✅ Clean complete."

fclean: down clean
	@echo "🔥 Removing custom images and leaving swarm..."
	@docker image rm inception_nginx inception_mariadb inception_wordpress 2>/dev/null || true
	@docker system prune -af --volumes
# 	@docker volume rm inception_mariadb_data inception_wordpress_data inception_redis_data inception_portainer_data
# 	@set -a; . $(ENV_FILE); set +a; \
# 	rm -rf $${DB_DATA_DIR} $${WP_DATA_DIR} $${REDIS_DATA_DIR} $${PORTAINER_DATA_DIR}; \
	echo "🗑️ Local data directories removed."
	@docker swarm leave --force 2>/dev/null || true
	@echo "✅ Full clean complete."

prune:
	@echo "🧽 Cleaning Docker system..."
	docker system prune -af --volumes

re: fclean build up
	@echo "🔁 Stack rebuilt and redeployed successfully ✅"


# make build   # builds all images from srcs/requirements/*
# make up        # deploys stack + auto setup
# make ps      # check running stack services
# down	Removes stack only
# clean	Removes stack + unused containers, networks, and volumes
# fclean	Everything (stack, images, Swarm, volumes)+ removes local data
# make re        # full rebuild and redeploy
