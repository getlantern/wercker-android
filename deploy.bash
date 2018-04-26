#!/usr/bin/env bash

docker build -t getlantern/wercker-android .

echo "****************Login with user 'getlantern' and the password in 1pass under Docker Hub****************"
docker login
docker push getlantern/wercker-android
