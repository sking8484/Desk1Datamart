include ./env/.env

build-env-prod:
	. ./env/.env-prod && envsubst < env/.env-template > env/.env

build-env-local:
	. ./env/.env-local &&envsubst < env/.env-template > env/.env

build-image:
	docker build -t $(DOCKER_IMAGE_TAG) .; \
	docker push $(DOCKER_IMAGE_TAG);

.ONESHELL:
check-env-local:
ifeq ("$(ENV)", "LOCAL")
	@echo "Running Locally"
else 
	@echo "ENV is set to prod. Please adjust"
	exit 1
endif
.ONESHELL:
run-containers-local:check-env-local 
	@docker run -p 8080:8080 --name $(DOCKER_IMAGE_NAME) -d $(DOCKER_IMAGE_TAG);
	@docker run -p $(MYSQL_PORT):3306 --name mysql -e MYSQL_ROOT_PASSWORD=$(MYSQL_PASSWORD) -d mysql 

.ONESHELL:
test-local:
	@docker run -p $(MYSQL_PORT):3306 --name mysql -e MYSQL_ROOT_PASSWORD=$(MYSQL_PASSWORD) -d mysql
	sleep 10
	cargo test
	@docker rm --force mysql

.ONESHELL:
deploy-local: run-containers-local
	@echo "Deploy Locally"

.ONESHELL:
destroy-local:
	@docker rm --force $(DOCKER_IMAGE_NAME)
	@docker rm --force mysql
