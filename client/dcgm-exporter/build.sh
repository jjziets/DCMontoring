#!/bin/bash

# Set variables
DOCKER_USERNAME="jjziets"
IMAGE_NAME="dcgm-exporter"
TAG="latest"

# Navigate to the directory of the Dockerfile
# Uncomment and set the correct path if needed
# cd /path/to/your/dockerfile

# Build the Docker image
echo "Building the Docker image..."
docker build -t $DOCKER_USERNAME/$IMAGE_NAME:$TAG .

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Docker image built successfully."
else
    echo "Docker build failed, exiting."
    exit 1
fi

# Push the Docker image to Docker Hub
echo "Pushing the image to Docker Hub..."
docker push $DOCKER_USERNAME/$IMAGE_NAME:$TAG

# Check if the push was successful
if [ $? -eq 0 ]; then
    echo "Docker image pushed successfully."
else
    echo "Docker push failed, exiting."
    exit 1
fi

echo "Operation completed."
