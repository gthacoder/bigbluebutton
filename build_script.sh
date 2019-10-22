#!/bin/bash
set -ev

files=`git diff --name-only HEAD..$TRAVIS_BRANCH`
if [[ $files = *"bigbluebutton-html5"* ]]; then
  cd bigbluebutton-html5
  curl https://install.meteor.com/ | sh
  meteor npm install
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
    {
      git clone --single-branch -b bbb22 https://github.com/MaximKhlobystov/docker.git
      cp -r docker/{mod,setup.sh,supervisord.conf} .
      cp -r docker/Dockerfile Dockerfile.test
      docker build -t bbb -f Dockerfile.test .
      #docker run -d -p 80:80/tcp -p 443:443/tcp -p 1935:1935 -p 5066:5066 -p 3478:3478 -p 3478:3478/udp bbb -h localhost
      docker run --privileged -d -p 80:80/tcp -p 443:443/tcp -p 1935:1935 -p 5066:5066 -p 3478:3478 -p 3478:3478/udp bbb -h localhost
    } > /dev/null

    #echo "----------"
    #echo "secret"
    #conf1=$(docker exec $(docker ps -q) bbb-conf --secret | grep "Secret:")
    #secret=$(echo $conf1 | cut -d' ' -f2)
    #echo "SECRET:"
    #echo $secret

    #cd bigbluebutton-html5/tests/webdriverio
    #cat .testing-env
    #> .testing-env
    #echo "TESTING_SERVER='http://localhost/bigbluebutton/api/'" > .testing-env
    #echo "TESTING_SECRET='$secret'" >> .testing-env
    #cat .testing-env
    #cd ../../..
    #ls

    container=$(docker ps -q)
    echo $container

    #echo "1"
    #docker exec $container ls /etc/supervisord.conf
    #echo "2"
    #docker exec $container ls /etc/supervisor/supervisord.conf
    #echo "3"
    #docker exec $container ls /etc/supervisor/conf.d/
    #docker exec $container ln -s  /etc/supervisor/supervisord.conf /etc/supervisord.conf
    echo "before start"
    #docker exec $container bash
    docker exec $container supervisorctl status
    docker exec $container service supervisor start
    #service supervisor start
    echo "after start"
    #docker exec $container supervisorctl status

    #echo "LOGIN"
    #docker exec $container bash

    #supervisorctl status
    #echo "STOPPING HTML5 CLIENT"
    #supervisorctl stop bbb-html5
    #supervisorctl status

    #git clone https://github.com/bigbluebutton/bigbluebutton.git
    #cd bigbluebutton/bigbluebutton-html5
    #curl https://install.meteor.com/ | sh
    #meteor npm install
    #ROOT_URL=http://127.0.0.1/html5client NODE_ENV=development METEOR_ALLOW_SUPERUSER=true meteor &
    #exit

    #echo "OUTSIDE CONTAINER"
    #cat .testing-env

    echo "check:"
    wget localhost/html5client/check -q -O -

    echo "FINISH"
  fi
fi

#files=`git diff --name-only HEAD..$TRAVIS_BRANCH`
#git diff --name-only HEAD..$TRAVIS_BRANCH
#if [[ $files = *"bigbluebutton-html5"* ]]; then
#  cd bigbluebutton-html5
#  curl https://install.meteor.com/ | sh
#  meteor npm install
#  cd ..
#  if [ $1 = linter ]
#  then
#    html5_files=""
#    list=$(echo $files | tr " " "\n")
#    for file in $list
#    do
#      if [[ $file = bigbluebutton-html5* ]] && [[ -e $file ]]
#      then
#        html5_files+=" $file"
#      fi
#    done
#    bigbluebutton-html5/node_modules/.bin/eslint --ext .jsx,.js $html5_files
#  elif [ $1 = acceptance_tests ]
#  then
#    {
#      git clone --single-branch -b update-html5 https://github.com/bigbluebutton/docker.git
#      cp -r docker/{mod,setup.sh,supervisord.conf} .
#      cp -r docker/Dockerfile Dockerfile.test
#      docker build -t b2 -f Dockerfile.test .
#    } > /dev/null
#    docker run -i -d --privileged=true -p 80:80/tcp -p 443:443/tcp -p 1935:1935 -p 5066:5066 -p 3478:3478 -p 3478:3478/udp b2 -h localhost /bin/bash
#    echo "----------"
#    echo "container"
#    container=$(docker ps -q)
#    echo "CONTAINER:"
#    echo $container
#    echo "----------"
#    echo "status"
#    status=$(docker exec $container bbb-conf --status)
#    echo "STATUS:"
#    echo $status
#    echo "FINISH"
#  fi
#fi
