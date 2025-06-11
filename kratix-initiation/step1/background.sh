git clone https://github.com/syntasso/kratix.git
cd kratix
./quick-start.sh >> /tmp/kratix.log 2>&1
if [ $? -eq 0 ]; then
    touch /tmp/kratixinstalled
else
    echo "failed" > /tmp/kratixinstalled
    exit 1
fi
echo "Kratix installation completed successfully."