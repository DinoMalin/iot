#!/bin/sh

curl -sfL https://get.k3s.io | sh -

until kubectl get nodes 2>/dev/null; do
	sleep 1
done

kubectl apply -f /shared/app1.yaml
kubectl expose deployment nginx --type=NodePort --name=nginx-deployment
