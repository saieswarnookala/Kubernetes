#!/bin/bash
# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF
# Apply sysctl params without reboot
sudo sysctl --system
sysctl net.ipv4.ip_forward
# Add Docker's official GPG key:
sudo apt-get update
sleep 10
sudo apt-get install ca-certificates curl
sleep 10
sudo install -m 0755 -d /etc/apt/keyrings
sleep 10
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sleep 5
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sleep 5
#install containerd.io
sudo apt-get install containerd.io
sleep 25
sudo rm /etc/containerd/config.toml
sudo chmod 777 /etc/containerd/
{
    sudo mkdir -p /etc/containerd
    containerd config default | sed 's/SystemdCgroup = false/SystemdCgroup = true/' | sudo tee /etc/containerd/config.toml
}
echo "[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true" > /etc/containerd/config.toml
sudo systemctl restart containerd
sudo apt-get update
sleep 10
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
sleep 90
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sleep 60
sudo apt-get install -y kubelet kubeadm kubectl
sleep 100
sudo apt-mark hold kubelet kubeadm kubectl
#(Optional) Enable the kubelet service before running kubeadm:
sudo systemctl enable --now kubelet
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
sleep 30
# installing pod network kube fannel
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
sleep 20
kubectl create ns kube-flannel
kubectl label --overwrite ns kube-flannel pod-security.kubernetes.io/enforce=privileged
helm repo add flannel https://flannel-io.github.io/flannel/
helm install flannel --set podCidr="10.244.0.0/16" --namespace kube-flannel flannel/flannel
mkdir -p /opt/cni/bin
curl -O -L https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz
tar -C /opt/cni/bin -xzf cni-plugins-linux-amd64-v1.2.0.tgz
