#!/bin/bash

CURRENT=$(docker images --format "{{.Tag}}" omkar-app | head -2 | tail -1)

echo "Rolling back to previous version: $CURRENT"

docker stop omkar-app-container || true
docker rm omkar-app-container || true
docker run -d -p 5000:5000 --name omkar-app-container omkar-app:$CURRENT

echo "Rollback complete! Running version: $CURRENT"
