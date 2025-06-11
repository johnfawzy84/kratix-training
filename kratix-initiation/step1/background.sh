# Create a new user 'kratixuser' if it doesn't exist
if ! id "kratixuser" &>/dev/null; then
    sudo useradd -m -s /bin/bash kratixuser
fi

# Switch to the new user for the rest of the script
# Add kratixuser to the sudo group to allow sudo usage
sudo usermod -aG sudo kratixuser
echo "kratixuser ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/kratixuser

sudo -i -u kratixuser
cd $HOME
touch /tmp/kratixusercreated

sudo -u kratixuser mkdir homebrew && sudo -u kratixuser curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew

echo 'export PATH="$HOME/homebrew/bin:$PATH"' >> /home/kratixuser/.bashrc
export PATH="$HOME/homebrew/bin:$PATH"

touch /tmp/homebrewinstalled

sudo -u kratixuser brew install kind kubectl yq minio-mc
touch /tmp/brewtoolsinstalled

