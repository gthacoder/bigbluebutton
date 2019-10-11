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
      git clone --single-branch -b bbb-2-2 https://github.com/MaximKhlobystov/docker.git
      cp -r docker/{mod,setup.sh,supervisord.conf} .
      cp -r docker/Dockerfile Dockerfile.test
      docker build -t bbb -f Dockerfile.test .
      docker run -d -p 80:80/tcp -p 443:443/tcp -p 1935:1935 -p 5066:5066 -p 3478:3478 -p 3478:3478/udp bbb -h localhost
    } > /dev/null

    #sleep 300

    #echo "----------"
    #echo "container"
    #container=$(docker ps -q)
    #echo "CONTAINER:"
    #echo $container

    #docker exec $(docker ps -q) bbb-conf --status

    #docker exec -it $container bash
    #bbb-conf --status

    echo "----------"
    echo "secret"
    conf1=$(docker exec $(docker ps -q) bbb-conf --secret | grep "Secret:")
    secret=$(echo $conf1 | cut -d' ' -f2)
    echo "SECRET:"
    echo $secret

    cd bigbluebutton-html5/tests/webdriverio
    cat .testing-env
    > .testing-env
    echo "TESTING_SERVER='http://localhost/bigbluebutton/api/'" > .testing-env
    echo "TESTING_SECRET='$secret'" >> .testing-env
    cat .testing-env
    cd ../../..
    ls

    container=$(docker ps -q)
    docker exec -i $container bash

    supervisorctl status
    echo "STOPPING HTML5 CLIENT"
    supervisorctl stop bbb-html5
    supervisorctl status

    git clone https://github.com/bigbluebutton/bigbluebutton.git
    cd bigbluebutton/bigbluebutton-html5
    curl https://install.meteor.com/ | sh
    meteor npm install
    npm start &
    exit

    echo "OUTSIDE CONTAINER"
    cat .testing-env

    echo "check:"
    wget localhost/html5client/check -q -O -

    #echo "localhost:"
    #wget localhost -q -O -
    #echo "check:"
    #wget localhost/html5client/check -q -O -

    #conf1=$(docker exec $(docker ps -q) bbb-conf --secret | grep "Secret:")
    #secret=$(echo $conf1 | cut -d' ' -f2)
    #echo "secret:"
    #echo $secret
    #conf2=$(docker exec $(docker ps -q) bbb-conf --secret | grep "URL:")
    #url=$(echo $conf2 | cut -d' ' -f2)
    #url+="api/"
    #echo "url:"
    #echo $url

    #cd bigbluebutton-html5/tests/webdriverio
    #cat .testing-env
    #> .testing-env
    #echo "TESTING_SERVER='http://localhost/bigbluebutton/api/'" > .testing-env
    #echo "TESTING_SECRET='$secret'" >> .testing-env
    #cat .testing-env
    #cd ../../..

    #ls

    #wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    #sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    #sudo apt-get update
    #sudo apt-get install google-chrome-stable

    #sudo apt-get install xvfb

    #cd bigbluebutton-html5
    #./node_modules/.bin/webdriver-manager update --gecko=false --versions.chrome=v77.0.3865.90-1
    #xvfb-run ./node_modules/.bin/webdriver-manager start --versions.chrome=v77.0.3865.90-1 &
    #sleep 5

    #sudo bbb-conf --check
    #sudo bbb-conf --status

    #npm install
    #npm start &
    #sleep 180

    #cat tests/webdriverio/.testing-env

    #npm test -- --spec ./tests/webdriverio/specs/chat.spec.js

    echo "FINISH"
  fi
fi
