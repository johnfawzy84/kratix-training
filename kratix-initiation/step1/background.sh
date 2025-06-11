set -x # to test stderr output in /var/log/killercoda
echo starting... # to test stdout output in /var/log/killercoda
apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release 
echo done > /tmp/installcacertificates