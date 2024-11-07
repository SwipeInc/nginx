#! /bin/bash
VERSION=1.27.2-brotli

aws ecr get-login-password --region af-south-1 --profile ccba | docker login --username AWS --password-stdin 194083492183.dkr.ecr.af-south-1.amazonaws.com

docker build --platform linux/amd64 -t nginx_noheader .

docker tag nginx_noheader:latest 194083492183.dkr.ecr.af-south-1.amazonaws.com/nginx_noheader_brotli:latest
docker tag nginx_noheader:latest 194083492183.dkr.ecr.af-south-1.amazonaws.com/nginx_noheader_brotli:${VERSION}
docker push 194083492183.dkr.ecr.af-south-1.amazonaws.com/nginx_noheader_brotli:latest
docker push 194083492183.dkr.ecr.af-south-1.amazonaws.com/nginx_noheader_brotli:${VERSION}