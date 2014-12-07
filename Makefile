REGISTRY=registry.giantswarm.io/seiffert
PROJECT_DIR=/opt/symfony
MAKEFILE_DIR=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

COMPOSER=docker run -it --rm -v $(MAKEFILE_DIR)/php-fpm/symfony:/opt/workspace pseiffert/composer
SYMFONY=docker run -it --rm -v $(MAKEFILE_DIR)/php-fpm/symfony:/opt/workspace --entrypoint php pseiffert/php-cli app/console

.PHONY=all build run-dev push stop-dev rm-dev install-dependencies

all: build

build: install-dependencies dump-assets
	cp -R php-fpm/symfony/web/bundles nginx/assets/
	docker build -t $(REGISTRY)/symfony-nginx nginx
	docker build -t $(REGISTRY)/symfony-fpm php-fpm

run-dev: stop-dev rm-dev
	docker run -d --name fpm -v $(MAKEFILE_DIR)/php-fpm/symfony:$(PROJECT_DIR) $(REGISTRY)/symfony-fpm
	docker run -d --name nginx -v $(MAKEFILE_DIR)/php-fpm/symfony:$(PROJECT_DIR) --link fpm:fpm -p 8000:80 $(REGISTRY)/symfony-nginx

push: build
	docker push $(REGISTRY)/symfony-nginx
	docker push $(REGISTRY)/symfony-fpm

install-dependencies:
	$(COMPOSER) install

dump-assets:
	$(SYMFONY) assets:install

stop-dev:
	docker stop nginx > /dev/null 2> /dev/null && \
		echo "Stopped Nginx container" || \
		echo "Nginx not running"
	docker stop fpm > /dev/null 2> /dev/null && \
		echo "Stopped PHP-FPM container" || \
		echo "PHP-FPM not running"

rm-dev:
	docker rm nginx > /dev/null 2> /dev/null && \
		echo "Removed Nginx container" || \
		echo "Nginx container not found"
	docker rm fpm > /dev/null 2> /dev/null && \
		echo "Removed PHP-FPM container" || \
		echo "PHP-FPM container not found"
