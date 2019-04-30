#!/bin/bash
set -ev

{
  git clone --single-branch -b update-html5 https://github.com/bigbluebutton/docker.git
  cp -r docker/{mod,restart.sh,setup.sh,supervisord.conf} .
  cp -r docker/Dockerfile Dockerfile.test
  docker build -t b2 -f Dockerfile.test .
  docker=$(docker run -d -p 80:80/tcp -p 443:443/tcp -p 1935:1935 -p 5066:5066 -p 3478:3478 -p 3478:3478/udp b2 -h localhost)
  echo $docker
} > /dev/null

cd tests/puppeteer/core
conf=$(docker exec $(docker ps -q) bbb-conf --secret | grep "Secret:")
secret=$(echo $conf | cut -d' ' -f2)
export BBB_SHARED_SECRET=$secret
node html5-check.js

echo "test"
