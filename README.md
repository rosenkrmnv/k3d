# Local Kubernetes Cluster Setup with K3d

This guide will walk you through setting up a local Kubernetes cluster with K3d using a Taskfile. The steps include installing K3d and creating a cluster.

---

## Prerequisites (Ubuntu 24.*)

```sh
./prerequisites.sh

```

---

## Run the Setup

Navigate to **k3d-cluster-setup** and run the setup task to create and configure the local Kubernetes cluster:
    ```sh
    task setup
    ```

## Tasks Overview

The setup task will perform the following steps:

1. **Install K3d:** Installs K3d for managing the Kubernetes cluster.
2. **Create Cluster:** Creates a new Kubernetes cluster with K3d.
3. **Verify Cluster:** Verifies that the Kubernetes cluster is running.
4. **Switch Context:** Switches the context to the new K3d cluster.
5. **Print Setup Complete:** Prints a message indicating the setup is complete.
