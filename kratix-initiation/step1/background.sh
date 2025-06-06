# Create a new user 'kratixuser' if it doesn't exist
if ! id "kratixuser" &>/dev/null; then
    sudo useradd -m -s /bin/bash kratixuser
fi

# Switch to the new user for the rest of the script
sudo -i -u kratixuser
cd $HOME

#install brew: 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#install kind : 
# For AMD64 / x86_64
brew install kind

#install docker :
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER

#install kubectl
brew install kubectl

#install yq
brew install yq

#install minio
brew install minio-mc

#install git
brew install git

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

touch /tmp/kindclusterfinished
# Install cert-manager
kubectl apply --filename https://github.com/cert-manager/cert-manager/releases/download/v1.15.0/cert-manager.yaml
# Wait for cert-manager pods to be ready
echo "Waiting for cert-manager pods to be ready..."
kubectl -n cert-manager wait --for=condition=Available --timeout=120s deployment/cert-manager deployment/cert-manager-webhook deployment/cert-manager-cainjector

# from the root of the Kratix repository
kubectl apply --filename config/samples/minio-install.yaml

kubectl apply --filename https://github.com/syntasso/kratix/releases/latest/download/kratix.yaml
