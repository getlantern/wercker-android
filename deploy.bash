#!/usr/bin/env bash

docker build -t getlantern/wercker-android .

echo "********\nLogin with user 'getlantern' and the password in 1pass under Docker Hub\n********"
docker login
docker push getlantern/wercker-android
