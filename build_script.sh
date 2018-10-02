#!/bin/bash
set -ev

if [[ $(git diff --name-only HEAD..testing-base) = *"bigbluebutton-html5"* ]]; then
  echo "HTML5"

  cd bigbluebutton-html5
  docker build -t b2 -f Dockerfile.test .
  docker=$(docker run -d -p 80:80/tcp -p 443:443/tcp -p 1935:1935 -p 5066:5066 -p 3478:3478 -p 3478:3478/udp b2 -h localhost)
  echo $docker
  cd tests/puppeteer
  npm install
  conf=$(docker exec $(docker ps -q) bbb-conf --secret | grep "Secret:")
  secret=$(echo $conf | cut -d' ' -f2)
  export BBB_SHARED_SECRET=$secret

  cd ../..
  curl https://install.meteor.com/ | sh
  meteor npm install
  cd tests/puppeteer
  npm install
  cd ../../..
  FILES=`git diff --name-only HEAD..$TRAVIS_BRANCH`
  echo "FILES:"
  echo $FILES
  bigbluebutton-html5/node_modules/.bin/eslint --ext .jsx,.js $(git diff --name-only HEAD..testing-base)
else
  echo "not HTML5"
fi
