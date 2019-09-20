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
      git clone --single-branch -b update-html5 https://github.com/bigbluebutton/docker.git
      cp -r docker/{mod,setup.sh,supervisord.conf} .
      cp -r docker/Dockerfile Dockerfile.test
      docker build -t b2 -f Dockerfile.test .
      docker=$(docker run -d -p 80:80/tcp -p 443:443/tcp -p 1935:1935 -p 5066:5066 -p 3478:3478 -p 3478:3478/udp b2 -h localhost)
      echo $docker
    } > /dev/null

    conf1=$(docker exec $(docker ps -q) bbb-conf --secret | grep "Secret:")
    secret1=$(echo $conf1 | cut -d' ' -f2)
    echo "secret1:"
    echo $secret1

    ls

    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    sudo apt-get update
    sudo apt-get install google-chrome-stable

    sudo apt-get install xvfb

    cd bigbluebutton-html5
    ./node_modules/.bin/webdriver-manager update --gecko=false
    xvfb-run ./node_modules/.bin/webdriver-manager start &

    #dpkg -l | grep systemd
    #apt-get install systemd

    #sudo systemctl status bbb-html5
    #sudo systemctl stop bbb-html5
    #sudo systemctl status bbb-html5

    npm start &

    #cd bigbluebutton-html5/tests/puppeteer/core
    #conf=$(docker exec $(docker ps -q) bbb-conf --secret | grep "Secret:")
    #secret=$(echo $conf | cut -d' ' -f2)
    #echo $secret
    #export BBB_SHARED_SECRET=$secret
    #node html5-check.js
    #cd ../../..
    #npm test

    url=$(docker exec $(docker ps -q) bbb-conf --secret | grep "URL:" | cut -d' ' -f2)
    url+="api/"
    echo "URL:"
    echo $url
    secret=$(docker exec $(docker ps -q) bbb-conf --secret | grep "Secret:" | cut -d' ' -f2)
    echo "Secret:"
    echo $secret

    echo "FINISH"
  fi
fi
