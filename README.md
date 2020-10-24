# ansible_role_prometheus

Playbook para crear un cluster Kubernetes con Minikube + instalar Prometheus y grafana vía Helm.

Testeado con Virtualbox + vagrant.

roles:
- docker
- kubectl
- minikube 
- helm

scripts:
- prometheus
