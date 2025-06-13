## Automated Environment Setup for Kratix Workshop

This guide summarizes the automated steps performed by the setup script to prepare your environment for the Kratix workshop. The process ensures all prerequisites are met, tools are installed, and the Kratix platform is ready for use. You do **not** need to run these steps manually; they are executed for you.

---

### 1. User Setup: `kratixuser`

A dedicated user `kratixuser` is created (if it does not exist) and added to both the `sudo` and `docker` groups.

- **Motivation:** Provides a non-root user with the necessary privileges to run Docker and administrative commands without `sudo` password prompts, this is needed for brew to install the needed tools. 
- **Reference:** [Linux User Management](https://www.cyberciti.biz/faq/howto-add-remove-user-account/)

---

### 4. Homebrew Installation

[Homebrew](https://brew.sh/) is installed for `kratixuser` to manage and install required CLI tools.

- **Motivation:** Simplifies the installation of cross-platform CLI tools.

---

### 5. CLI Tools Installation

The following tools are installed via Homebrew:

- [`yq`](https://github.com/mikefarah/yq): YAML processor for configuration management.
- [`minio-mc`](https://min.io/docs/minio/linux/reference/minio-mc.html): MinIO client for interacting with S3-compatible storage.
- [`k9s`](https://k9scli.io/): Terminal UI for managing Kubernetes clusters.

- **Motivation:** These tools are essential for interacting with Kubernetes and MinIO during the workshop.

---

### 6. Kratix Repository Cloning

The [Kratix repository](https://github.com/syntasso/kratix) is cloned to provide all configuration files, scripts, and resources needed for the workshop.

- **Motivation:** Ensures access to the latest Kratix resources and scripts.

---

### 7. Environment Variables

The script sets environment variables for Kubernetes contexts:

- `PLATFORM`: The admin context for the platform cluster.
- `WORKER`: The admin context for the worker cluster.

- **Motivation:** Simplifies referencing the correct Kubernetes clusters in subsequent commands. both env. variables are set for the same cluster for the lack of resources in the training enviroment. 

---

### 8. Cert-Manager Installation

[cert-manager](https://cert-manager.io/) is installed on the platform cluster to automate the management and issuance of TLS certificates.

- **Motivation:** Enables secure communication and certificate management for Kratix components. This is needed for Kratix installation. 

---

### 9. MinIO Installation

[MinIO](https://min.io/) is deployed on the platform cluster to provide S3-compatible object storage for Kratix.

- **Motivation:** Supplies a storage backend for Kratix artifacts and state. This will work as a state-store between the Platform cluster and worker cluster. 

---

### 10. GitOps Tooling Installation

The script runs the Kratix-provided `install-gitops` script to set up [Flux](https://fluxcd.io/) and other GitOps tooling on the worker cluster.

- **Motivation:** Enables automated deployment and management of resources via GitOps practices. This will add everything needed to configure flux in the worker cluster so that it can fetch the manifests from MinIO state-store and apply them in the worker cluster. 

---

### 11. Flux System Readiness

The script waits for all Flux system components (helm-controller, kustomize-controller, notification-controller, source-controller) to become available.

- **Motivation:** Ensures the GitOps system is fully operational before proceeding.

---

### 12. MinIO Bucket Endpoint Correction

Due to a known issue in the upstream `install-gitops` script, the MinIO bucket endpoint may be set to an incorrect IP. The script:

- Extracts the correct cluster IP from the Kubernetes control plane endpoint.
- Patches the MinIO Bucket resource to update the endpoint with the correct IP and port.

- **Motivation:** Ensures Kratix components can reliably access the MinIO storage backend.

---

### 13. Completion Signal

A file `/tmp/step1finished` is created to signal that the setup process has completed successfully.

---

**Summary:**  
This automated process ensures your environment is fully prepared for the Kratix workshop, with all dependencies installed, clusters configured, and known issues addressed. For more details on Kratix, visit the [official documentation](https://kratix.io/docs/).

