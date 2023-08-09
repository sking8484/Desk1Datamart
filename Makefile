include ./env/.env

	
check-env:
	echo $(ENV)
build-image:
	docker build -t $(DOCKER_IMAGE_TAG) .; \
	docker push $(DOCKER_IMAGE_TAG);


.ONESHELL:
run-containers-locally:
	. env/.env-local
	echo $$DB_PASSWORD
	docker run -p 8080:8080 --name $(DOCKER_IMAGE_NAME) -d $(DOCKER_IMAGE_TAG);
	docker run -p 3307:3306 --name mysql -e MYSQL_ROOT_PASSWORD=$$DB_PASSWORD -d mysql 

.ONESHELL:
deploy-local: run-containers-locally
	echo "Deploy Locally"

.ONESHELL:
destroy-local:
	docker rm --force $(DOCKER_IMAGE_NAME)
	docker rm --force mysql
