#!/bin/bash

# Update package lists
sudo apt-get update

# Install required packages
sudo apt-get install -y net-tools docker.io nginx systemd

# Install devopsfetch script
sudo cp devopsfetch /usr/local/bin/devopsfetch
sudo chmod +x /usr/local/bin/devopsfetch

# Create systemd service file
cat <<EOF | sudo tee /etc/systemd/system/devopsfetch.service
[Unit]
Description=DevOpsFetch Service

[Service]
ExecStart=/usr/local/bin/devopsfetch --time '00:00:00' '23:59:59'
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable the service
sudo systemctl daemon-reload
sudo systemctl enable devopsfetch.service
sudo systemctl start devopsfetch.service

# Display installation complete message
echo "Installation complete. DevOpsFetch is now set up and running."
