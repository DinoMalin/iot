#!/bin/bash

# install docker
if ! which docker 2>&1 >/dev/null; then
	pacman -S docker
	systemctl enable docker.service
	systemctl start docker.service
fi

# install k3d
if ! which k3d 2>&1 >/dev/null; then
	wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi

# install kubectl
if ! which kubectl 2>&1 >/dev/null; then
	pacman -S kubectl
fi

if ! which argocd 2>&1 >/dev/null; then
	pacman -S argocd
fi
