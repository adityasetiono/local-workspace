MYSQL_CHART_NAME?=stable/mysql
MYSQL_RELEASE_NAME?=mysql
NAMESPACE?=dev

mysql_install:
	helm install ${MYSQL_RELEASE_NAME} ${MYSQL_CHART_NAME} -f mysql/values.yaml

mysql_upgrade:
	helm upgrade ${MYSQL_RELEASE_NAME} ${MYSQL_CHART_NAME} -f mysql/values.yaml

mysql_restart: mysql_upgrade

mysql_stop:
	kubectl delete deployments ${MYSQL_RELEASE_NAME} -n ${NAMESPACE} && kubectl delete services ${MYSQL_RELEASE_NAME} -n ${NAMESPACE}

mysql_echo_password:
	kubectl get secret -n ${NAMESPACE} ${MYSQL_RELEASE_NAME} -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo