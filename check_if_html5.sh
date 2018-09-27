#!/bin/bash
set -ev

if [[ $(git diff --name-only HEAD..testing-base) = *"bigbluebutton-html5"* ]]; then
  echo "HTML5"
  cd bigbluebutton-html5
  curl https://install.meteor.com/ | sh
  meteor npm install
  cd tests/puppeteer
  npm install
  cd ../../..
  FILES=`git diff --name-only HEAD..$TRAVIS_BRANCH`
  bigbluebutton-html5/node_modules/.bin/eslint --ext .jsx,.js $(git diff --name-only HEAD..testing-base)
else
  echo "not HTML5"
fi
