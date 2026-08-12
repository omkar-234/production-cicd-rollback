#!/bin/bash

VERSION=$1
echo "Deploying version: $VERSION"

# Juna container band karo
docker stop omkar-app-container || true
docker rm omkar-app-container || true

# Navi image build karo
docker build -t omkar-app:$VERSION ./app
docker tag omkar-app:$VERSION omkar-app:latest

# Container start karo
docker run -d -p 5000:5000 --name omkar-app-container omkar-app:$VERSION

# Health check - 30 seconds wait
echo "Health check karto..."
sleep 10

STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/health)

if [ "$STATUS" == "200" ]; then
    echo "✅ Deploy successful! Version $VERSION live!"
else
    echo "❌ Deploy failed! Rollback starting..."
    bash /home/ubuntu/rollback-project/rollback.sh
    exit 1
fi
