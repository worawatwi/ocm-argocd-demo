#!/bin/bash

set -x

HUB_TOKEN=$1
HUB_API_SERVER=$2
CLUSTER_NAME=$3

clusteradm join --hub-token $HUB_TOKEN \
 --hub-apiserver $HUB_API_SERVER \
 --wait \
 --cluster-name $CLUSTER_NAME

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl apply -f managed