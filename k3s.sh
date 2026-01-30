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
kubectl apply -f k8s/prometheus-ingress.yaml
kubectl apply -f k8s/grafana-ingress.yaml

# kubectl apply -f k8s/test-rate-limit.yaml
# kubectl apply -f k8s/suricata-config.yaml
# kubectl apply -f k8s/suricata-daemonset.yaml
# kubectl apply -f k8s/suricata-rules.yaml
# kubectl apply -f k8s/promethe.yaml
# kubectl apply -f k8s/prometheus-service.yaml
# kubectl apply -f k8s/grafana.yaml
# kubectl apply -f k8s/grafana-service.yaml

# add the prometheus helm repo
# 

#!/bin/bash

set -e

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
helm repo add grafana https://grafana.github.io/helm-charts || true
helm repo update || true

kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

helm status prometheus -n monitoring >/dev/null 2>&1 || \
helm install prometheus prometheus-community/prometheus -n monitoring

helm status grafana -n monitoring >/dev/null 2>&1 || \
helm install grafana grafana/grafana -n monitoring

kubectl patch svc prometheus-server -n monitoring \
  -p '{"spec":{"type":"NodePort"}}' || true

kubectl patch svc grafana -n monitoring \
  -p '{"spec":{"type":"NodePort"}}' || true

kubectl patch secret grafana -n monitoring \
  -p '{"data":{"admin-password":"YWRtaW5AMTIz"}}' || true

sleep 10

kubectl get all -n todo
kubectl get all -n monitoring
