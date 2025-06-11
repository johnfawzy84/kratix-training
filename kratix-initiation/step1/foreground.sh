echo "kratix training v0.1.10"
while [ ! -f /tmp/installcacertificates ]; do sleep 1; done
echo "ca-certificates installed successfully."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
groupadd docker
# while [ ! -f /tmp/dockerinstalled ]; do sleep 1; done
echo "Docker installed successfully."

# Create a new user 'kratixuser' if it doesn't exist
if ! id "kratixuser" &>/dev/null; then
    useradd -m -s /bin/bash kratixuser
fi

# Switch to the new user for the rest of the script
# Add kratixuser to the sudo group to allow sudo usage
usermod -aG sudo kratixuser
echo "kratixuser ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/kratixuser
mkdir /home/kratixuser/homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C /home/kratixuser/homebrew


echo "Switching to kratixuser..."
su - kratixuser
echo 'export PATH="$HOME/homebrew/bin:$PATH"' >> /home/kratixuser/.bashrc
export PATH="$HOME/homebrew/bin:$PATH"
touch /tmp/brewinstalled