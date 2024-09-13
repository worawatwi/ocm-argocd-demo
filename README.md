# Example OCM ArgoCD

## Prerequisites

- clusteradm
- argocd

## Getting Started

Create hub cluster and managed clusters:
```
docker compose up -d
```

Get kube config files:
```
docker exec hub-cluster cat /etc/rancher/k3s/k3s.yaml > ~/.kube/hub-cluster.config
docker exec managed-cluster-1 cat /etc/rancher/k3s/k3s.yaml > ~/.kube/managed-cluster-1.config
sed -i '' -e 's/127.0.0.1:6443/127.0.0.1:6444/g' ~/.kube/managed-cluster-1.config
```

Bootstrap OCM hub cluster manager:
```
KUBECONFIG=~/.kube/hub-cluster.config clusteradm init --wait
```
This will print command to register a managed server.

Register managed cluster to hub:
```
KUBECONFIG=~/.kube/managed-cluster-1.config clusteradm join --hub-token <hub_token> --hub-apiserver <hub_apiserver_url> --wait --cluster-name cluster-1
```

On the hub cluster, accept the join request.
```
KUBECONFIG=~/.kube/hub-cluster.config clusteradm accept --clusters cluster-1
```

Verify the managed cluster was created successfully:
```
KUBECONFIG=~/.kube/hub-cluster.config kubectl get managedcluster
```
Then should print result resembles the following:
```
NAME        HUB ACCEPTED   MANAGED CLUSTER URLS   JOINED   AVAILABLE   AGE
cluster-1   true                                  True     True        2m1s
```

Install ArgoCD on both clusters

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

