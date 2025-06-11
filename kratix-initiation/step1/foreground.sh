echo "kratix training v0.1.10"
while [ ! -f /tmp/kratixusercreated ]; do sleep 1; done
echo "Switching to kratixuser..."
su - kratixuser
while [ ! -f /tmp/homebrewinstalled ]; do sleep 1; done
echo "homebrew installed..."
while [ ! -f /tmp/brewtoolsinstalled ]; do sleep 1; done
echo "tools installed with brew..."
