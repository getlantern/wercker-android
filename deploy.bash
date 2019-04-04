#!/usr/bin/env bash

echo "****************Login with user 'getlantern' and the password in 1pass under Docker Hub****************"
docker login
docker build -t getlantern/wercker-android .
docker push getlantern/wercker-android
