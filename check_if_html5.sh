#!/bin/bash

set -e

CHANGED_FILES=`git diff --name-only puppeteer-test...${TRAVIS_COMMIT}`

echo $CHANGED_FILES
