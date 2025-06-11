echo "kratix training v0.1.10"
while [ ! -f /tmp/kratixusercreated ]; do sleep 1; done
echo "Switching to kratixuser..."
su - kratixuser
sudo -u kratixuser mkdir homebrew && sudo -u kratixuser curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
echo 'export PATH="$HOME/homebrew/bin:$PATH"' >> /home/kratixuser/.bashrc
export PATH="$HOME/homebrew/bin:$PATH"
touch /tmp/homebrewinstalled

while [ ! -f /tmp/brewtoolsinstalled ]; do sleep 1; done
echo "tools installed with brew..."
