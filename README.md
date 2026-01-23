# Todo App + WAF + IDS on k3s (Dev Lab)

## Prereqs
- k3s installed and running
- kubectl configured to connect to k3s
- Docker (or build image and load into k3s)

## Quick steps

1. Build docker image locally and load into k3s (local workflow)
   ```bash
   # Build image
   docker build -t todo-app:latest -f docker/Dockerfile .

   # For k3s, load image into k3s containerd:
   # If k3s installed as single-node, you can use "ctr" inside k3s:
   k3s ctr image import $(docker save todo-app:latest -o todo-app.tar && echo todo-app.tar)
   # Simpler approach: push to your registry and change image in k8s/todo-deployment.yaml
