#!/bin/bash

# Step 1: Install Libraries
sudo apt update
sudo apt upgrade -y
# Install GIT
sudo apt install git -y
# Install gcloud sdk for gke 
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin -y
# Install Kubectl
sudo apt-get install kubectl -y

# DOCKER
# Install necessary packages
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add the GPG key for the Docker repository
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add the Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock
sudo systemctl restart docker

# Install Jenkins

sudo apt install openjdk-11-jre -y

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update

sudo apt-get install jenkins

sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Step 2: Save the service account key on the VM using wget
wget --header="Metadata-Flavor: Google" -O svacckey.json http://metadata.google.internal/computeMetadata/v1/instance/attributes/sa-1-key

# Step 3: Decrypt the key to JSON format
cat svacckey.json | base64 -d > svacckeyz.json

# Set to Desired Project
gcloud config set project final-project-iti-hendawyy

# Step 4: Activate the service account with the key
gcloud auth activate-service-account --key-file=svacckeyz.json

# Step 5: Configure Docker
gcloud auth configure-docker us-east1-docker.pkg.dev

# Step 6: Login to Docker using the key
cat svacckey.json | docker login -u _json_key_base64 --password-stdin https://us-east1-docker.pkg.dev

# Step 7: Connect to the cluster
gcloud container clusters get-credentials gcp-k8s --zone europe-west1-b --project final-project-iti-hendawyy --internal-ip

# Step 8: Enable master global access
gcloud container clusters update gcp-k8s --zone europe-west1-b --enable-master-global-access
