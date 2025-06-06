#!/bin/bash

# install docker
if ! which docker /dev/null 2>&1; then
	pacman -S docker
	systemctl enable docker.service
	systemctl start docker.service
fi

# install k3d
if ! which k3d /dev/null 2>&1; then
	wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi

# install kubectl
if ! which kubectl /dev/null 2>&1; then
	pacman -S kubectl
fi

if ! which argocd /dev/null 2>&1; then
	pacman -S argocd
fi
