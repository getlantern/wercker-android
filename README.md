# Docker image for Docker for Android builds

## Test

`docker build -t getlantern/wercker-android .`

## Deploy

Just run 'deploy.bash', which essentially does the following:

```
docker login
docker build -t getlantern/wercker-android .
docker push getlantern/wercker-android
```

For logging in the docker hub user name is **getlantern** and the password is in 1pass under "**Docker Hub**".
