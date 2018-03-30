# Docker image for Docker for Android builds

## Test

`docker build -t getlantern/wercker-android .`

## Deploy

```
docker build -t getlantern/wercker-android .
docker login
docker push getlantern/wercker-android
```

For logging in the docker hub user name is getlantern and the password is in 1pass.
