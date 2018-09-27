#!/bin/bash
set -ev

if [[ $(git diff --name-only HEAD..testing-base) = *"bigbluebutton-html5"* ]]; then
  echo "HTML5"
fi
