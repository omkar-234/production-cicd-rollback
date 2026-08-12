#!/bin/bash

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "Usage: ./deploy.sh <version>"
    exit 1
fi

echo "Deploying version: $VERSION"

docker stop omkar-app-container || true
docker rm omkar-app-container || true

echo "Building Docker image..."
docker build -t omkar-app:$VERSION ./app

docker tag omkar-app:$VERSION omkar-app:latest

echo "Starting new container..."
docker run -d -p 5001:5000 --name omkar-app-container omkar-app:$VERSION

echo "Health check karto..."
sleep 10

HOST=127.0.0.1
PORT=5001
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://${HOST}:${PORT}/health)

if [ "$STATUS" == "200" ]; then
    echo "Deploy successful! Version $VERSION live!"
else
    echo "Deploy failed! Rollback starting..."
    bash /home/ubuntu/rollback-project/rollback.sh
    exit 1
fi
