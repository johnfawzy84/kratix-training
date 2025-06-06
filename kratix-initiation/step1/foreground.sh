echo "kratix training v0.1.8"
while [ ! -f /tmp/kratixusercreated ]; do sleep 1; done
echo "Switching to kratixuser..."
su - kratixuser
echo "Installing brew..."
while [ ! -f /tmp/brewinstalled ]; do sleep 1; done
if cat /tmp/brewinstalled | grep -q "failed"; then
    echo "Failed to install brew"
    exit 1
fi
echo "brew installed!"
echo "Installing tools with brew..."
while [ ! -f /tmp/brewtoolsinstalled ]; do sleep 1; done
echo "Tools installed!"
echo "Installing docker..."
while [ ! -f /tmp/dockerinstalled ]; do sleep 1; done
echo "Docker installed!"
echo "cloning kratix rep..."
while [ ! -f /tmp/kratixcloned ]; do sleep 1; done
echo "Kratix repo cloned!"
echo "Creating clusters..."
while [ ! -f /tmp/kindclusterscreated ]; do sleep 1; done
echo "Clusters created!"
echo "Installing kratix..."
while [ ! -f /tmp/kratixinstalled ]; do sleep 1; done
echo "kratix installed!"
kubectl --context $PLATFORM cluster-info
kubectl --context $WORKER cluster-info
