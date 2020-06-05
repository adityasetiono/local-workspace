# INIT
NAMESPACE?=dev
NGINX_NAMESPACE?=nginx
CLUSTER_NAME?=local-cluster
cluster_create:
	kind create cluster --name ${CLUSTER_NAME}
namespaces_create:
	(kubectl create namespace ${NAMESPACE} || true) && \
	(kubectl create namespace ${NGINX_NAMESPACE} || true)

# MYSQL
MYSQL_CHART_NAME?=stable/mysql
MYSQL_RELEASE_NAME?=mysql

mysql_install:
	helm install ${MYSQL_RELEASE_NAME} ${MYSQL_CHART_NAME} -n ${NAMESPACE} -f mysql/values.yaml

mysql_upgrade:
	helm upgrade ${MYSQL_RELEASE_NAME} ${MYSQL_CHART_NAME} -n ${NAMESPACE} -f mysql/values.yaml

mysql_restart: mysql_upgrade

mysql_stop:
	kubectl delete deployments ${MYSQL_RELEASE_NAME} -n ${NAMESPACE} && kubectl delete services ${MYSQL_RELEASE_NAME} -n ${NAMESPACE}

mysql_echo_password:
	kubectl get secret -n ${NAMESPACE} ${MYSQL_RELEASE_NAME} -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo

# NGINX
NGINX_CHART_NAME?=stable/nginx-ingress
NGINX_RELEASE_NAME?=nginx

nginx_install:
	helm install ${NGINX_RELEASE_NAME} ${NGINX_CHART_NAME} -n ${NGINX_NAMESPACE} -f nginx/values.yaml
nginx_upgrade:
	helm upgrade ${NGINX_RELEASE_NAME} ${NGINX_CHART_NAME} -n ${NGINX_NAMESPACE} -f nginx/values.yaml

# MAILHOG
MAILHOG_CHART_NAME?=codecentric/mailhog
MAILHOG_RELEASE_NAME?=mailhog

mailhog_install:
	helm install ${MAILHOG_RELEASE_NAME} ${MAILHOG_CHART_NAME} -n ${NAMESPACE} -f mailhog/values.yaml

mailhog_upgrade:
	helm upgrade ${MAILHOG_RELEASE_NAME} ${MAILHOG_CHART_NAME} -n ${NAMESPACE} -f mailhog/values.yaml

mailhog_restart: mailhog_upgrade

mailhog_stop:
	kubectl delete deployments ${MAILHOG_RELEASE_NAME} -n ${NAMESPACE} && kubectl delete services ${MAILHOG_RELEASE_NAME} -n ${NAMESPACE}

mailhog_delete:
	helm delete ${MAILHOG_RELEASE_NAME}