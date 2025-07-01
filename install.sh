#!/bin/bash

set -e
set -u

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# -------------------------
# Install Docker
# -------------------------
if ! command_exists docker; then
  echo "Docker not found. Installing Docker..."

  for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo apt-get remove -y $pkg || true
  done

  sudo apt-get update
  sudo apt-get install -y ca-certificates curl

  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  echo \
   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
     $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
     sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  echo "Docker installed successfully."
else
  echo "Docker is already installed. Skipping..."
fi

# -------------------------
# Install Helm
# -------------------------
if ! command_exists helm; then
  echo "Helm not found. Installing Helm..."
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh
  rm get_helm.sh
  echo "Helm installed successfully."
else
  echo "Helm is already installed. Skipping..."
fi

# -------------------------
# Install kubectl
# -------------------------
if ! command_exists kubectl; then
  echo "kubectl not found. Installing kubectl..."
  ARCH=$(dpkg --print-architecture)
  VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
  curl -LO "https://dl.k8s.io/release/$VERSION/bin/linux/$ARCH/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  rm kubectl
  echo "kubectl installed successfully."
else
  echo "kubectl is already installed. Skipping..."
fi

# -------------------------
# Install Task
# -------------------------
if ! command_exists task; then
  echo "Task not found. Installing Task..."
  sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin/
  echo "Task installed successfully."
else
  echo "Task is already installed. Skipping..."
fi

# -------------------------
# Check k3d cluster status
# -------------------------
if command_exists k3d; then
  echo "Checking existing k3d clusters..."
  if [ "$(k3d cluster list | wc -l)" -le 1 ]; then
    echo "No k3d clusters found. Running 'task install'..."
    cd k3d-cluster-setup
    task install
  else
    echo "k3d cluster(s) already exist. Skipping 'task install'."
  fi
else
  echo "k3d is not installed. Skipping k3d cluster check and 'task install'."
fi

