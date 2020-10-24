#!/bin/bash
REPO=https://charts.bitnami.com/bitnami

echo "++ Instalando ingress addon ++"
minikube addons enable ingress

echo "++ Instalar Kubeapps ++"
helm repo add bitnami $REPO
kubectl create namespace kubeapps
helm install kubeapps --namespace kubeapps bitnami/kubeapps --set useHelm3=true

echo "++ Creacion del API TOKEN para acceder al Dashboard de Kubeapps ++"
kubectl create serviceaccount kubeapps-operator
kubectl create clusterrolebinding kubeapps-operator --clusterrole=cluster-admin --serviceaccount=default:kubeapps-operator

echo "++ Mostrar el TOKEN ++"
kubectl get secret $(kubectl get serviceaccount kubeapps-operator -o jsonpath='{range .secrets[*]}{.name}{"\n"}{end}' | grep kubeapps-operator-token) -o jsonpath='{.data.token}' -o go-template='{{.data.token | base64decode}}' && echo

echo "++ Esperar que el POD levante e Iniciar el Dashboard ++"
export POD_NAME=$(kubectl -n kubeapps get pods -l "app=kubeapps,release=kubeapps" -o jsonpath="{.items[0].metadata.name}")
while [[ $(kubectl -n kubeapps get pods "$POD_NAME" -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for pod" && sleep 10; done
kubectl -n kubeapps port-forward --address 0.0.0.0 "$POD_NAME" 8080:8080

# minikube start --driver=docker
# esperar a que iniciar el pod 
# acceder vía navegador http://localhost:8080
 