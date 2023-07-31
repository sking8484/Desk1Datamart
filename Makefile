include .env

SET_EKS_VPC_ID = $(eval EKS_VPC_ID = $(shell aws \
								 eks describe-cluster \
								 --name="$(EKS_CLUSTER_NAME)" \
						 		 --query "cluster.resourcesVpcConfig.vpcId" \
						     --profile $(AWS_PROFILE) \
						     --output text))

SET_EKS_SUBNET_ID = $(eval EKS_SUBNET_IDS = $(shell aws \
										ec2 describe-subnets \
										--filters "Name=vpc-id,Values=$(EKS_VPC_ID)" \
										--query 'Subnets[*].SubnetId' \
						 				--profile $(AWS_PROFILE) \
						 				--output text))

build-image:
	docker build -t $(DOCKER_IMAGE_TAG) .; \
	docker push $(DOCKER_IMAGE_TAG);

create-eks-cluster:
	eksctl create cluster --name $(EKS_CLUSTER_NAME) \
		--region $(AWS_DEFAULT_REGION) \
		--with-oidc \
		--profile $(AWS_PROFILE)
create-eks-namespace:create-eks-cluster
	kubectl create namespace $(NAMESPACE)

install-ack:create-eks-namespace
	aws ecr-public get-login-password \
		--region us-east-1 | helm registry login \
		--username AWS --password-stdin public.ecr.aws && \
		helm install -n $(NAMESPACE) \
		oci://public.ecr.aws/aws-controllers-k8s/rds-chart \
		--version=0.0.27 --generate-name --set=aws.region=$(AWS_DEFAULT_REGION)



populate-ids:
	$(SET_EKS_VPC_ID)
	$(SET_EKS_SUBNET_ID)

create-subnet-group-file:populate-ids
	source desk1-datamart/bin/activate && \
		export EKS_SUBNET_IDS="$(EKS_SUBNET_IDS)" && export EKS_VPC_ID="$(EKS_VPC_ID)" &&\
		python deployment_helper.py $(HELPER_SUBNET_FLAG)

apply-subnet-groups:create-subnet-group-file

	kubectl apply -f db-subnet-groups.yaml;


deploy-helm-chart:
	cd ./datamart-chart/datamart; \
	pwd; \
	helm install datamart . --set ImageName=$(DOCKER_IMAGE_TAG);







deploy:
