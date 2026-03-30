#!/bin/bash
set -e

IMAGE=412128478995.dkr.ecr.us-east-1.amazonaws.com/service1:latest
TEMP_PORT=9090
HOST_PORT=8081
NAME=service1

echo "Logging into ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 412128478995.dkr.ecr.us-east-1.amazonaws.com

echo "Pulling latest image..."
docker pull $IMAGE

echo "Starting new container on temp port..."
docker stop $NAME-new || true
docker rm $NAME-new || true
docker run -d -p $TEMP_PORT:8080 --name $NAME-new $IMAGE

echo "Waiting for app to be ready..."
for i in {1..20}; do
  if curl -s http://localhost:$TEMP_PORT/health > /dev/null; then
    echo "New container is ready!"
    break
  fi
  sleep 3
done

echo "Stopping old container..."
docker stop $NAME-container || true
docker rm $NAME-container || true

echo "Starting new container on live port..."
docker run -d -p $HOST_PORT:8080 --name $NAME-container $IMAGE

echo "Cleaning temp container..."
docker stop $NAME-new || true
docker rm $NAME-new || true

echo "Deployment complete!"