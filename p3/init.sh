#!/bin/bash

source .env

CLUSTER_NAME=mycluster
APP_NAME=iot
REPO="https://github.com/dinomalin/jcario-iot"

if [ $1 = "destroy" ]; then
	kubectl delete namespace argocd
	kubectl delete namespace dev
	k3d cluster delete $CLUSTER_NAME
	exit 0
fi

if [ -z $PASSWORD ]; then
	PASSWORD="dino"
fi

k3d cluster create $CLUSTER_NAME --port 8888:8888@loadbalancer
kubectl create namespace argocd
kubectl create namespace dev

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

until argocd admin initial-password -n argocd >/dev/null 2>&1; do
	sleep 1
done

PASS=$(argocd admin initial-password -n argocd | head -n 1)
IP=$(kubectl get svc argocd-server -n argocd | tail -1 | awk '{print $4}')

until argocd login $IP --insecure --username admin --password $PASS >/dev/null 2>&1; do
	sleep 1
done

argocd account update-password --current-password=$PASS --new-password=$PASSWORD

kubectl config set-context --current --namespace=argocd
argocd app create $APP_NAME --repo $REPO --path . --dest-server https://kubernetes.default.svc --dest-namespace dev --sync-policy automated
argocd app sync $APP_NAME
