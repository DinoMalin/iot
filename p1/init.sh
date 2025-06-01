#!/bin/sh

SERVER_IP="192.168.56.110"
TOKEN="/var/lib/rancher/k3s/server/node-token"

if [ $1 = "server" ]; then
	curl -sfL https://get.k3s.io | sh -

	until [ -e $TOKEN ]; do
		sleep 1
	done

	cat $TOKEN > /shared/token
elif [ $1 = "agent" ]; then
	curl -sfL https://get.k3s.io | K3S_URL=https://$SERVER_IP:6443 K3S_TOKEN=$(cat /shared/token) sh -
fi
