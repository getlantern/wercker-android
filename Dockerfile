FROM mingc/android-build-box:latest
MAINTAINER Lantern Team <admin@getlantern.org>

RUN apt-get update && apt-get install -y build-essential curl git apt-utils unzip file pkg-config lsof libpcap-dev libappindicator3-dev libwebkit2gtk-4.0-dev

ENV GO_VERSION 1.14.3

RUN curl -sSL https://storage.googleapis.com/golang/go$GO_VERSION.linux-__GOARCH__.tar.gz | tar -xvzf - -C /usr/local
RUN mkdir -p /usr/local/gocode/bin

# Environment variables
ENV GOPATH /usr/local/gocode/
ENV PATH $PATH:/usr/local/go/bin
ENV PATH $PATH:$GOPATH/bin

# Install gomobile
RUN GO111MODULE=off go get golang.org/x/mobile/cmd/gomobile
RUN GO111MODULE=off go get golang.org/x/mobile/cmd/gobind
RUN GO111MODULE=off gomobile init

RUN GO111MODULE=off go get golang.org/x/tools/cmd/cover
RUN GO111MODULE=off go get github.com/mattn/goveralls

# Install Gradle
ENV GRADLE_VERSION 6.4.1
RUN cd /usr/local/ && \
wget https://downloads.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \
unzip gradle-$GRADLE_VERSION-bin.zip && \
mv gradle-$GRADLE_VERSION gradle && \
rm gradle-$GRADLE_VERSION-bin.zip
ENV GRADLE_HOME /usr/local/gradle-$GRADLE_VERSION
ENV PATH $PATH:/usr/local/gradle/bin
