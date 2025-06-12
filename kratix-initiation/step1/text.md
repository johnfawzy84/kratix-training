## Prerequisites

This guide will help you set up your environment for the Kratix workshop, following the instructions described [here](https://docs.kratix.io/workshop/part-0/intro). Each step below includes context and reasoning to help you understand why it is necessary.

0. **Ensure `kratixuser` is in the `docker` group**

    Docker requires users to have the appropriate permissions to run containers. By adding `kratixuser` to the `docker` group, you ensure that Docker commands can be executed without needing `sudo`.

    `newgrp docker`{{exec}}

1. **Install required tools**

    The following tools are essential for managing Kubernetes clusters and related resources:
    - `kind`: Used to run local Kubernetes clusters using Docker containers.
    - `kubectl`: The Kubernetes command-line tool for interacting with clusters.
    - `yq`: A portable command-line YAML processor, useful for editing configuration files.
    - `minio-mc`: The MinIO Client, used for interacting with MinIO object storage.
    - `k9s`: A terminal UI to interact with your Kubernetes clusters.

    Installing these tools ensures you have all the utilities needed for the workshop.

    `brew install kind yq minio-mc k9s`{{exec}}

2. **Clone the Kratix repository**

    The Kratix repository contains all the configuration files, scripts, and resources required for the workshop. Cloning it locally allows you to access and modify these files as needed.

    ```sh 
    git clone https://github.com/syntasso/kratix
    cd kratix
    ```{{exec}}

3. **Create the platform cluster using Kind**

    The platform cluster acts as the control plane for Kratix, managing resources and orchestrating workloads. Using Kind (Kubernetes in Docker), you can quickly spin up a local Kubernetes cluster for this purpose.

    Before creating the cluster, ensure there are no existing Kind clusters running to avoid conflicts.

    ```sh
    # make sure there are no clusters running
    kind delete clusters --all

    kind create cluster \
        --name platform \
        --image kindest/node:v1.27.3 \
        --config config/samples/kind-platform-config.yaml
    ```{{exec}}

4. **Create the worker cluster using Kind**

    The worker cluster is where workloads will be scheduled and run. Like the platform cluster, it is created using Kind, but with a different configuration to distinguish it as a worker.

    ```sh
    # make sure there are no clusters running
    kind create cluster \
        --name worker \
        --image kindest/node:v1.27.3 \
        --config config/samples/kind-worker-config.yaml
    ```{{exec}}

5. **Export environment variables for cluster contexts**

    Setting the `PLATFORM` and `WORKER` environment variables makes it easier to reference the correct Kubernetes contexts in subsequent commands, reducing the risk of applying changes to the wrong cluster.

    ```sh
    export PLATFORM="kind-platform"
    export WORKER="kubernetes-admin@kubernetes"
    ```{{exec}}

6. **Install cert-manager on the platform cluster**

    Cert-manager is a Kubernetes add-on to automate the management and issuance of TLS certificates. Kratix relies on cert-manager for secure communication and certificate management.

    ```sh
    kubectl --context $PLATFORM apply --filename https://github.com/cert-manager/cert-manager/releases/download/v1.15.0/cert-manager.yaml
    ```{{exec}}

7. **Verify cert-manager installation**

    Checking the cert-manager pods ensures that the installation was successful and that the components are running as expected.

    ```sh
    kubectl --context $PLATFORM get pods --namespace cert-manager
    ```{{copy}}

8. **Install MinIO on the platform cluster**

    MinIO provides S3-compatible object storage, which is used by Kratix for storing artifacts and state. Installing MinIO ensures that Kratix has the storage backend it needs.

    ```sh
    kubectl --context $PLATFORM apply --filename config/samples/minio-install.yaml
    ```{{exec}}

9. **Install worker cluster prerequisites**

    The worker cluster needs to be prepared with GitOps tooling (such as Flux) to enable automated deployment and management of resources. The provided script sets up these prerequisites.

    ```sh
    ./scripts/install-gitops --context $WORKER --path worker-cluster
    ```{{exec}}

10. **Wait for Flux to start on the worker cluster**

    Monitoring the Flux deployments ensures that the GitOps tooling is up and running before proceeding with further steps.

    ```sh
    kubectl --context $WORKER get deployments --namespace flux-system --watch
    ```{{exec}}

