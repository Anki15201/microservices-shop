#!/bin/bash
set -e

# Define version
VERSION="v0.155.0"

# Download Helmfile
echo "Downloading Helmfile $VERSION..."
curl -LO https://github.com/helmfile/helmfile/releases/download/${VERSION}/helmfile_${VERSION}_linux_amd64.tar.gz

# Extract
echo "Extracting Helmfile..."
tar -xvzf helmfile_${VERSION}_linux_amd64.tar.gz

# Move to /usr/local/bin
echo "Installing Helmfile to /usr/local/bin..."
sudo mv helmfile /usr/local/bin/
sudo chmod +x /usr/local/bin/helmfile

# Clean up
rm helmfile_${VERSION}_linux_amd64.tar.gz

# Verify
echo "Helmfile installation complete!"
helmfile --version
