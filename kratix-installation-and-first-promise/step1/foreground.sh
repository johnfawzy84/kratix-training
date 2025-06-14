echo "kratix training v0.1.10"
if ! command -v docker &> /dev/null; then
    echo "Docker installation failed or docker command not found."
    exit 1
fi
echo "Docker installed successfully."
chmod +r /etc/kubernetes/admin.conf # Ensure the Kubernetes admin config file is readable
chmod a+w /etc/kubernetes/admin.conf
# Create a new user 'kratixuser' if it doesn't exist
if ! id "kratixuser" &>/dev/null; then
    useradd -m -s /bin/bash kratixuser
fi

# Switch to the new user for the rest of the script
# Add kratixuser to the sudo group to allow sudo usage
usermod -aG sudo docker kratixuser
echo "kratixuser ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/kratixuser
newgrp docker

echo "Switching to kratixuser..."
su - kratixuser
mkdir /home/kratixuser/homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C /home/kratixuser/homebrew
echo 'export PATH="$HOME/homebrew/bin:$PATH"' >> /home/kratixuser/.bashrc
export PATH="$HOME/homebrew/bin:$PATH"
export KUBECONFIG=/etc/kubernetes/admin.conf
brew install yq minio-mc k9s
exit
exit
export PATH="/home/kratixuser/homebrew/bin:$PATH"
git clone https://github.com/syntasso/kratix
cd kratix
export PLATFORM="kubernetes-admin@kubernetes"
export WORKER="kubernetes-admin@kubernetes"
kubectl --context $PLATFORM apply --filename https://github.com/cert-manager/cert-manager/releases/download/v1.15.0/cert-manager.yaml
#kubectl --context $PLATFORM get pods --namespace cert-manager --watch
echo "Waiting for cert-manager pods to be ready..."
kubectl --context $PLATFORM wait --for=condition=Available --timeout=180s deployment/cert-manager -n cert-manager
kubectl --context $PLATFORM wait --for=condition=Available --timeout=180s deployment/cert-manager-webhook -n cert-manager
kubectl --context $PLATFORM wait --for=condition=Available --timeout=180s deployment/cert-manager-cainjector -n cert-manager
echo "cert-manager is ready."
kubectl --context $PLATFORM apply --filename config/samples/minio-install.yaml
./scripts/install-gitops --context $WORKER --path worker-cluster -k training -t $PLATFORM
echo "Waiting for Flux system to be up and running..."
kubectl --context $PLATFORM -n flux-system wait --for=condition=Available --timeout=180s deployment/helm-controller
kubectl --context $PLATFORM -n flux-system wait --for=condition=Available --timeout=180s deployment/kustomize-controller
kubectl --context $PLATFORM -n flux-system wait --for=condition=Available --timeout=180s deployment/notification-controller
kubectl --context $PLATFORM -n flux-system wait --for=condition=Available --timeout=180s deployment/source-controller
echo "Flux system is ready."

# --- Fix MinIO Bucket IP if patch_kind_networking set it incorrectly ---

# Extract the cluster IP from the Kubernetes control plane endpoint
MINIO_IP=$(kubectl cluster-info | grep 'Kubernetes control plane' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n1)

if [ -n "$MINIO_IP" ]; then
  echo "Patching Bucket resource with correct MinIO IP: $MINIO_IP"
  # Get the current endpoint value (assumes default namespace and resource name)
  CURRENT_ENDPOINT=$(kubectl get bucket kratix -o jsonpath='{.spec.endpoint}' -n flux-system  2>/dev/null)
  if [[ "$CURRENT_ENDPOINT" =~ ^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):([0-9]+)$ ]]; then
    PORT="${BASH_REMATCH[2]}"
    NEW_ENDPOINT="$MINIO_IP:$PORT"
    kubectl patch bucket kratix --type='json' -n flux-system -p="[{\"op\": \"replace\", \"path\": \"/spec/endpoint\", \"value\": \"$NEW_ENDPOINT\"}]" || echo "Failed to patch Bucket resource"
  else
    # fallback to port 9000 if parsing fails
    kubectl patch bucket kratix --type='json' -n flux-system -p="[{\"op\": \"replace\", \"path\": \"/spec/endpoint\", \"value\": \"$MINIO_IP:9000\"}]" || echo "Failed to patch Bucket resource"
  fi
else
  echo "Could not determine MinIO service IP. Skipping Bucket patch."
fi

curl -sf https://labs.iximiuz.com/cli/install.sh | sh

touch /tmp/step1finished