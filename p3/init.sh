#!/bin/bash

source .env

if [ -z $PASSWORD ]; then
	PASSWORD="dino"
fi

CLUSTER_NAME=mycluster
APP_NAME=iot

if [ $1 = "destroy" ]; then
	kubectl delete namespace argocd
	kubectl delete namespace dev
	k3d cluster delete $CLUSTER_NAME
	exit 0
fi

k3d cluster create $CLUSTER_NAME
kubectl create namespace argocd
kubectl create namespace dev

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# yeah we got to wait for it to be in place

PASS=$(argocd admin initial-password -n argocd | head -n 1)
IP=$(kubectl get svc argocd-server -n argocd | tail -1 | awk '{print $4}')

argocd login $IP --insecure --username admin --password $PASS
argocd account update-password --current-password=$PASS --new-password=$PASSWORD

kubectl config set-context --current --namespace=argocd
argocd app create $APP_NAME --repo https://github.com/dinomalin/jcario-iot
