echo "kratix training v0.1.10"
while [ ! -f /tmp/kratixusercreated ]; do sleep 1; done
echo "Switching to kratixuser..."
su - kratixuser



#install tools with brew:
echo "Installing required tools with brew..."
sudo -u kratixuser sudo -u kratixuser NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" & echo >> /home/kratixuser/.bashrc & echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/kratixuser/.bashrc & eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" & brew install kind kubectl yq minio-mc git & touch /tmp/brewinstalled
# Wait for brew to be installed
while [ ! -f /tmp/brewinstalled ]; do sleep 1; done
echo "Brew installed successfully."

#preparation : 
git clone https://github.com/syntasso/kratix
cd kratix

# make sure there are no clusters running
kind delete clusters --all

kind create cluster \
    --name platform \
    --image kindest/node:v1.27.3 \
    --config config/samples/kind-platform-config.yaml

kind create cluster \
    --name worker \
    --image kindest/node:v1.27.3 \
    --config config/samples/kind-worker-config.yaml


export PLATFORM="kind-platform"
export WORKER="kind-worker"

# Install cert-manager
kubectl apply --filename https://github.com/cert-manager/cert-manager/releases/download/v1.15.0/cert-manager.yaml
# Wait for cert-manager pods to be ready
echo "Waiting for cert-manager pods to be ready..."
kubectl -n cert-manager wait --for=condition=Available --timeout=120s deployment/cert-manager deployment/cert-manager-webhook deployment/cert-manager-cainjector

# from the root of the Kratix repository
kubectl apply --filename config/samples/minio-install.yaml

kubectl apply --filename https://github.com/syntasso/kratix/releases/latest/download/kratix.yaml
touch /tmp/kratixinstalled


kubectl --context $PLATFORM cluster-info
kubectl --context $WORKER cluster-info
