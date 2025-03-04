#! /bin/bash
VERSION=1.27.4-arm-brotli

aws ecr get-login-password --region eu-west-1 --profile livevoting-master | docker login --username AWS --password-stdin 142008789313.dkr.ecr.eu-west-1.amazonaws.com

docker build -t nginx_noheader -f Dockerfile.arm .

docker tag nginx_noheader:latest 142008789313.dkr.ecr.eu-west-1.amazonaws.com/nginx-no-headers:latest-arm
docker tag nginx_noheader:latest 142008789313.dkr.ecr.eu-west-1.amazonaws.com/nginx-no-headers:${VERSION}
docker push 142008789313.dkr.ecr.eu-west-1.amazonaws.com/nginx-no-headers:latest-arm
docker push 142008789313.dkr.ecr.eu-west-1.amazonaws.com/nginx-no-headers:${VERSION}