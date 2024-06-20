# Kubernetes Cluster Setup with Kubeadm, Kube-Flannel, Prometheus, Grafana, and LDAP

Welcome to the Kubernetes Cluster Setup repository! This repository contains configurations and scripts to set up a Kubernetes cluster using Kubeadm, Kube-Flannel for pod networking, and integration with Prometheus for monitoring. Future enhancements will include adding Grafana for visualization and LDAP for authentication.

![architecture_block_diagram](https://github.com/saieswarnookala/Kubernetes/assets/108252839/809323b0-bdd6-4432-bedd-77fec8ecc84e)


## Table of Contents

- [Introduction](#introduction)
- [Getting Started](#getting-started)
- [Cluster Setup](#cluster-setup)
  - [Initialize Master Node](#initialize-master-node)
    - [Manually](#manually)
    - [Using shell script](#using-shell-script)
  - [Join Worker Nodes](#join-worker-nodes)
- [Networking](#networking)
- [Monitoring](#monitoring)
  - [Prometheus](#prometheus)
    - [Set up Manually](#set-up-manually)
    - [set up using shell script](#set-up-using-shell-script)
  - [Grafana (Future)](#grafana-future)
- [Authentication](#authentication)
  - [LDAP (Future)](#ldap-future)
- [Best Practices](#best-practices)
- [Contributing](#contributing)
- [License](#license)

## Introduction

This repository provides a comprehensive guide to set up a Kubernetes cluster using Kubeadm and Kube-Flannel for pod networking. It also includes integration with Prometheus for monitoring the cluster. Future plans include adding Grafana for data visualization and LDAP for centralized authentication.
![K8s](https://github.com/saieswarnookala/Kubernetes/assets/108252839/1edcfae6-182c-4fdb-bb92-cbf63bc04270)

## Getting Started

To get started with setting up your Kubernetes cluster, ensure you have the following prerequisites:

### Prerequisites

- At least two Linux machines (one master and one worker node)
- [Kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Docker](https://docs.docker.com/get-docker/)
- [Kube-Flannel](https://github.com/flannel-io/flannel#deploying-flannel-manually)

### Installation


## Cluster Setup
### Initialize Master Node 
#### Manually
Follow the steps below to initialize the master node:

1. **Initialize the Kubernetes master:**
```
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

2. **Set up local kubeconfig:**

   ```sh
   mkdir -p $HOME/.kube
   sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
   sudo chown $(id -u):$(id -g) $HOME/.kube/config
   ```

3. **Deploy Kube-Flannel network:**

   ```sh
   kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
   ```
#### Using shell script
Clone this repository to your local machine:

```sh
git clone https://github.com/saieswarnookala/Kubernetes.git
cd Kubernetes
```
For automating the setup just run below scripts which includes complete setup of master node
```
. k8s_cluster.sh

```
### Join Worker Nodes

On each worker node, run the command provided by `kubeadm init` on the master node. It looks similar to this:

```sh
sudo kubeadm join <master-node-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```

## Networking

Kube-Flannel is used for pod networking. The Flannel configuration is deployed as part of the master node initialization.

## Monitoring

### Prometheus
![prometheus](https://github.com/saieswarnookala/Kubernetes/assets/108252839/e60b132d-20df-4ee8-86f4-24d4cbe1ea4d)

Prometheus is used for monitoring the Kubernetes cluster. Follow these steps to set up Prometheus:
#### Set up Manually 
1. **Deploy Prometheus using Helm:**

   ```sh
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   helm install prometheus prometheus-community/prometheus
   ```

2. **Verify Prometheus installation:**

   ```sh
   kubectl get pods -l "release=prometheus"
   ```
#### set up using shell script
   ```sh
   . prometheus.sh
   ```
### Grafana (Future)

Grafana will be added in future updates to provide enhanced data visualization capabilities.

## Authentication

### LDAP (Future)

LDAP integration will be added in future updates to provide centralized authentication and authorization.

## Best Practices

- Follow the [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/)
- Use [Helm](https://helm.sh/) for managing complex Kubernetes applications
- Ensure proper security by using [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

## Contributing

Contributions are welcome! If you have any examples or improvements to add, please fork this repository and submit a pull request.

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
```
This `README.md` provides a detailed overview of your project and guides users through the initial setup and future plans for enhancements. Feel free to modify it further to better fit your project's specific details and instructions.
```

