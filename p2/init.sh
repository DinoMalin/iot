#!/bin/sh

curl -sfL https://get.k3s.io | sh -

until kubectl get nodes 2>&1 2>/dev/null; do
	sleep 1
done

until kubectl get namespaces 2>&1 >/dev/null; do
	sleep 1
done

kubectl apply -f /shared/app1.yaml
kubectl apply -f /shared/app2.yaml
kubectl apply -f /shared/app3.yaml
kubectl apply -f /shared/ingress.yaml
