# Docker image for Docker for Android builds

## Test

`docker build -t getlantern/wercker-android:0.0.1 .`

## Deploy

**Just run './deploy.bash 0.0.1', which essentially does the following:**

```
docker login
docker build -t getlantern/wercker-android:0.0.1 .
docker push getlantern/wercker-android:0.0.1
```

For logging in the docker hub user name is **getlantern** and the password is in 1pass under "**Docker Hub**".
