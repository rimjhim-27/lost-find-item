.PHONY: help up down build test lint deploy-staging deploy-prod rollback logs shell db-shell

help:
	@echo "LFIS - Lost and Found Information System"
	@echo ""
	@echo "Local Development:"
	@echo "  make up          - Start all containers"
	@echo "  make down        - Stop all containers"
	@echo "  make build       - Rebuild containers"
	@echo "  make logs        - View container logs"
	@echo "  make shell       - Shell into app container"
	@echo "  make db-shell    - MySQL shell"
	@echo ""
	@echo "Code Quality:"
	@echo "  make test        - Run syntax checks"
	@echo "  make lint        - Run PHPStan analysis"
	@echo ""
	@echo "Deployment:"
	@echo "  make deploy-staging  - Deploy to staging"
	@echo "  make deploy-prod     - Deploy to production"
	@echo "  make rollback        - Rollback production"

up:
	docker-compose up -d

down:
	docker-compose down -v

build:
	docker-compose build --no-cache

test:
	docker-compose exec app find /var/www/html -name "*.php" -not -path "*/vendor/*" -exec php -l {} \;

lint:
	docker-compose exec app ./vendor/bin/phpstan analyse /var/www/html --level=5 --no-progress || true

logs:
	docker-compose logs -f

shell:
	docker-compose exec app bash

db-shell:
	docker-compose exec db mysql -u lfis_user -p lfis_db

deploy-staging:
	./deploy.sh staging

deploy-prod:
	./deploy.sh production

rollback:
	./deploy.sh production --rollback

clean:
	docker-compose down -v --rmi all --remove-orphans