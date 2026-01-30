#!/bin/bash
set -e

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
sleep 20
echo "⏳ Waiting for k3s API server to be ready..."

until kubectl get nodes >/dev/null 2>&1; do
  echo "Kubernetes API not ready yet... waiting"
  sleep 10
done

NAMESPACE="todo"

kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/secrets.yaml
kubectl apply -f k8s/configmap-todo-sql.yaml
kubectl apply -f k8s/mysql-pvc.yaml
kubectl apply -f k8s/mysql-deployment.yaml
kubectl apply -f k8s/todo-deployment.yaml
kubectl apply -f k8s/todo-service.yaml
kubectl apply -f k8s/ingress.yaml


# kubectl apply -f k8s/test-rate-limit.yaml
# kubectl apply -f k8s/suricata-config.yaml
# kubectl apply -f k8s/suricata-daemonset.yaml
# kubectl apply -f k8s/suricata-rules.yaml
# kubectl apply -f k8s/promethe.yaml
# kubectl apply -f k8s/prometheus-service.yaml
# kubectl apply -f k8s/grafana.yaml
# kubectl apply -f k8s/grafana-service.yaml

# add the prometheus helm repo
# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# helm repo update
# #create namespace
# kubectl create ns monitoring || true  
# # install prometheus from the helm repo
# helm install prometheus prometheus-community/prometheus -n monitoring

# # update the prometheus service's type to NodePort
# # kubectl edit service/prometheus-server
# kubectl patch svc prometheus-server -n monitoring -p '{"spec":{"type":"NodePort"}}'
# ## grafana
# helm repo add grafana https://grafana.github.io/helm-charts

# # update the repo
# helm repo update

# # install grafana
# helm install grafana grafana/grafana -n monitoring

# # update the grafana service's type to NodePort
# # kubectl edit service/grafana
# kubectl patch svc grafana -n monitoring   -p '{"spec":{"type":"NodePort"}}'

# # find the grafana admin password
# # copy admin password from the file
# # kubectl edit secret grafana
# kubectl patch secret grafana -n monitoring  -p '{"data":{"admin-password":"YWRtaW5AMTIz"}}'




echo "made by pruthviraj ingale all alone "
echo "all rights reserved "
echo " tiger group , sunbeam "

if kubectl get ns monitoring >/dev/null 2>&1; then
  echo "[INFO] Monitoring stack already installed"
else
  echo "[INFO] Installing monitoring stack"
  bash monitor.sh
fi

sleep 20

kubectl get all -n todo
kubectl get all -n monitoring
