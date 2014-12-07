# Symfony on Docker / Giant Swarm

This repository contains a show case that demonstrates the usage of [Docker](http://docker.com) and especially [Giant Swarm](http://giantswarm.io) to run Symfony applications.

## Directory Structure

The directory `nginx` contains the configuration for a Docker container that runs [Nginx](http://nginx.org) which passes requests on to the project's PHP container.

The directory `php-fpm` contains the configuration for a Docker container that runs PHP-FPM. In this directory, you also find the Symfony application. When using `make run-dev`, the Symfony application's directory will be mounted as a volume in can therefore be modified without restarting the container. When building the container however, this directory is copied into the container image.

## Make Targets

To **build** the application's containers, use

	make
	
this will also run composer install on your Symfony project.

To **run** the application **locally**, use

	make run-dev

To **push** the application to Giant Swarm's private registry, use

	make push
