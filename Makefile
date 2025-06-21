# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: daviles- <daviles-@student.madrid42.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/06/20 17:48:46 by daviles-          #+#    #+#              #
#    Updated: 2025/06/20 17:48:48 by daviles-         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Makefile for Docker Compose

# Define the Docker Compose configuration file
COMPOSE_FILE := srcs/docker-compose.yml

# Define the name of your Docker Compose project
PROJECT_NAME := inception

.PHONY: up down build start stop restart logs ps prune re

up:
	docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) up -d

down:
	docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) down --remove-orphans

build:
	docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) build

start:
	docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) start

stop:
	docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) stop

restart:: stop
restart:: start

logs:
	docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) logs -f

ps:
	docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) ps

prune: # will clean up the old image.
	docker system prune -af
	docker volume ls -q | xargs -I {} docker volume rm {}

re: down up

# --remove-orphans delete all the previous container generated bt docker-compose