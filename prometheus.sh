#!/bin/bash
REPO=https://kubernetes-charts.storage.googleapis.com

echo "++ Instalando ingress addon ++"
minikube addons enable ingress

echo "++ Instalar helm repo ++"
helm repo add stable $REPO
kubectl create namespace monitoring
helm install metrics -n monitoring stable/prometheus-operator 

echo "++ Esperar que el POD levante e Iniciar el Dashboard ++"
kubectl -n monitoring port-forward --address 0.0.0.0 svc/metrics-grafana 3000:80

# minikube start --driver=docker

# esperar a que iniciar el servicio 
# acceder vía navegador http://localhost:3000
# username: admin
# password: prom-operator 