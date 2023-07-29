include .env

build-image:
	docker build -t $(DOCKER_IMAGE_TAG) .; \
	docker push $(DOCKER_IMAGE_TAG);

create-eks-cluster:
	eksctl create cluster --name $(EKS_CLUSTER_NAME) --region $(AWS_DEFAULT_REGION)

create-eks-namespace:create-eks-cluster
	kubectl create namespace eks-sample-app

deploy-helm-chart:
	cd ./datamart-chart/datamart; \
	pwd; \
	helm install datamart . --set ImageName=$(DOCKER_IMAGE_TAG);







deploy:
