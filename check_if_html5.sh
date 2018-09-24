#!/bin/bash

#set -e

#CHANGED_FILES=`git diff --name-only puppeteer-test...${TRAVIS_COMMIT}`

#echo ${TRAVIS_COMMIT}
#echo `git show ${TRAVIS_COMMIT}`
#echo $CHANGED_FILES

#echo `git diff --name-only HEAD...$TRAVIS_BRANCH`

echo $TRAVIS_PULL_REQUEST_BRANCH
echo $TRAVIS_BRANCH
echo `git branch`
echo `git remote -v`
#echo `git diff --name-only $TRAVIS_BRANCH..$TRAVIS_PULL_REQUEST_BRANCH`
