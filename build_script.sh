#!/bin/bash

files=`git diff --name-only HEAD..$TRAVIS_BRANCH`
if [[ $files = *"bigbluebutton-html5"* ]]; then
  cd bigbluebutton-html5
  npm install
  cd ..
  if [ $1 = linter ]
  then
    html5_files=""
    list=$(echo $files | tr " " "\n")
    for file in $list
    do
      if [[ $file = bigbluebutton-html5* ]] && [[ -e $file ]]
      then
        html5_files+=" $file"
      fi
    done

    bigbluebutton-html5/node_modules/.bin/eslint --ext .jsx,.js $html5_files
  elif [ $1 = acceptance_tests ]
  then
    echo "START"
    df -h
    git clone --single-branch -b bbb-22 https://github.com/MaximKhlobystov/docker.git
    cp -r docker/{mod,setup.sh,supervisord.conf} .
    cp -r docker/Dockerfile Dockerfile.test
    docker build -t bbb -f Dockerfile.test .
    docker run --privileged -d -p 80:80/tcp -p 443:443/tcp -p 1935:1935 -p 5066:5066 -p 3478:3478 -p 3478:3478/udp bbb -h localhost

    container=$(docker ps -q)
    echo $container

    docker exec $container supervisorctl status
    docker exec $container cat /var/log/supervisord.log
    docker exec $container service supervisor status
    docker exec $container service supervisor restart

    echo "FINISH"
  fi
fi
