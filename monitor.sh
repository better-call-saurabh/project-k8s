# add the prometheus helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update
#create namespace
kubectl create ns monitoring || true  
# install prometheus from the helm repo
helm install prometheus prometheus-community/prometheus -n monitoring

# update the prometheus service's type to NodePort
# kubectl edit service/prometheus-server
kubectl patch svc prometheus-server -n monitoring -p '{"spec":{"type":"NodePort"}}'
## grafana
helm repo add grafana https://grafana.github.io/helm-charts

# update the repo
helm repo update

# install grafana
helm install grafana grafana/grafana -n monitoring

# update the grafana service's type to NodePort
# kubectl edit service/grafana
kubectl patch svc grafana -n monitoring   -p '{"spec":{"type":"NodePort"}}'

# find the grafana admin password
# copy admin password from the file
# kubectl edit secret grafana
kubectl patch secret grafana -n monitoring  -p '{"data":{"admin-password":"YWRtaW5AMTIz"}}'