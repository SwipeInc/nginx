#! /bin/bash
VERSION=1.20.1-brotli

aws ecr get-login-password --region eu-west-1 --profile dstv-aws-master | docker login --username AWS --password-stdin 240247221724.dkr.ecr.eu-west-1.amazonaws.com

docker build -t nginx_noheader .

docker tag nginx_noheader:latest 240247221724.dkr.ecr.eu-west-1.amazonaws.com/nginx_noheader:latest
docker tag nginx_noheader:latest 240247221724.dkr.ecr.eu-west-1.amazonaws.com/nginx_noheader:${VERSION}
docker push 240247221724.dkr.ecr.eu-west-1.amazonaws.com/nginx_noheader:latest
docker push 240247221724.dkr.ecr.eu-west-1.amazonaws.com/nginx_noheader:${VERSION}