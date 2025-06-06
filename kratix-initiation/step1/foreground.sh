echo "training v0.1.1"
su - kratixuser
echo "Starting step1 foreground script..."
echo waiting for step1-background-script to finish
while [ ! -f /tmp/kindclusterfinished ]; do sleep 1; done
echo Cluster creation finished!
kubectl --context $PLATFORM cluster-info
kubectl --context $WORKER cluster-info
