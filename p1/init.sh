#!/bin/sh

SERVER_IP="192.168.56.110"
TOKEN="/var/lib/rancher/k3s/server/node-token"
CONFIG="/etc/rancher/k3s/k3s.yaml"

if [ $1 = "server" ]; then
	curl -sfL https://get.k3s.io | sh -
	cat $TOKEN > /vagrant/token

	# sudo systemctl daemon-reload
	# sudo systemctl restart k3s
elif [ $1 = "agent" ]; then
	curl -sfL https://get.k3s.io | K3S_URL=https://$SERVER_IP:6443 K3S_TOKEN=$(cat /vagrant/token) sh -
fi
