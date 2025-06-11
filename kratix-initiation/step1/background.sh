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

while [ ! -f /tmp/homebrewinstalled ]; do sleep 1; done
echo "homebrew installed..."