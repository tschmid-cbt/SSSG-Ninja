#!/usr/bin/env bash
pip3 install --target=. --ignore-installed -r requirements.txt
rm -f test.zip
zip -9 -r -qq test.zip .
aws --profile CHANGE-ME lambda update-function-code --function-name CHANGE-ME --zip-file fileb://test.zip --no-publish
