FROM ubuntu:20.04
MAINTAINER Lantern Team <admin@getlantern.org>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

# Install build tools and native dependencies
RUN apt-get install -y pkg-config
RUN apt-get install -y lsof libpcap-dev libappindicator3-dev libwebkit2gtk-4.0-dev

# Install Java and other dev tools
RUN apt-get install -y apt-utils
RUN apt-get install -y openjdk-8-jdk curl wget unzip build-essential git git-lfs file

# Install Gradle
ENV GRADLE_VERSION 6.4.1
RUN cd /usr/local/ && \
wget https://downloads.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \
unzip gradle-$GRADLE_VERSION-bin.zip && \
mv gradle-$GRADLE_VERSION gradle && \
rm gradle-$GRADLE_VERSION-bin.zip
ENV GRADLE_HOME /usr/local/gradle-$GRADLE_VERSION
ENV PATH $PATH:/usr/local/gradle/bin

# Install Android SDK. You can update this from here:
# https://developer.android.com/studio#downloads
ENV SDK_TOOLS commandlinetools-linux-7302050_latest.zip

RUN mkdir -p /usr/local/android/cmdline-tools
COPY $SDK_TOOLS /usr/local/android/cmdline-tools

RUN cd /usr/local/android/cmdline-tools && \
unzip $SDK_TOOLS && \
rm $SDK_TOOLS && \
mv cmdline-tools latest

ENV ANDROID_HOME /usr/local/android/
ENV ANDROID_BIN /usr/local/android/cmdline-tools/latest/bin
ENV PATH=${ANDROID_BIN}:${PATH}

# Install Android tools
RUN yes | $ANDROID_BIN/sdkmanager --licenses
RUN yes | $ANDROID_BIN/sdkmanager "build-tools;30.0.2"
RUN yes | $ANDROID_BIN/sdkmanager platform-tools
RUN yes | $ANDROID_BIN/sdkmanager ndk-bundle
RUN yes | $ANDROID_BIN/sdkmanager "ndk;22.1.7171670"
RUN $ANDROID_BIN/sdkmanager "platforms;android-30"

# Install Go
ENV GO_VERSION 1.15.10

RUN mkdir /usr/local/go/ && \
cd /usr/local/go && \
wget https://redirector.gvt1.com/edgedl/go/go$GO_VERSION.linux-amd64.tar.gz && \
tar xvf go$GO_VERSION.linux-amd64.tar.gz && \
mv go go$GO_VERSION && \
rm go$GO_VERSION.linux-amd64.tar.gz

# Environment variables
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools
ENV PATH $PATH:$GRADLE_HOME/bin
ENV PATH $PATH:/usr/local/go/go$GO_VERSION/bin
ENV PATH $PATH:/usr/local/go/bin
ENV PATH $PATH:$ANDROID_HOME/ndk
ENV GOROOT /usr/local/go/go$GO_VERSION
ENV GOPATH /usr/local/go/

# Install gomobile
RUN GO111MODULE=off go get golang.org/x/mobile/cmd/gomobile
RUN GO111MODULE=off go get golang.org/x/mobile/cmd/gobind
RUN GO111MODULE=off gomobile init

RUN GO111MODULE=off go get golang.org/x/tools/cmd/cover
RUN GO111MODULE=off go get github.com/mattn/goveralls

# Install dep
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

# Genymotion Cloud
RUN apt-get install -y python3 python3-pip
RUN pip3 install gmsaas
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN gmsaas config set android-sdk-path $ANDROID_HOME

# Flutter
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_2.0.6-stable.tar.xz
RUN tar xf flutter_linux_2.0.6-stable.tar.xz
RUN mv flutter /usr/local/
