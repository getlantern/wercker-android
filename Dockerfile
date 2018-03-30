FROM ubuntu:16.04
MAINTAINER Ulysses Aalto <uaalto@getlantern.org>

RUN apt-get update

# Install Java RUN apt-get install -y openjdk-7-jre
RUN apt-get install -y apt-utils
RUN apt-get install -y openjdk-8-jdk curl wget unzip build-essential git file

# Install Android SDK
RUN mkdir /usr/local/android-sdk-tools && \
cd /usr/local/android-sdk-tools && \
wget --show-progress https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip

RUN cd /usr/local/android-sdk-tools && \
unzip sdk-tools-linux-3859397.zip && \
rm sdk-tools-linux-3859397.zip

ENV ANDROID_HOME /usr/local/android-sdk-tools
ENV ANDROID_BIN /usr/local/android-sdk-tools/tools/bin

# Install Android NDK
ENV ANDROID_NDK_VERSION r15c

RUN cd /usr/local && wget --show-progress https://dl.google.com/android/repository/android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip
RUN cd /usr/local && \
unzip android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip && \
mv android-ndk-$ANDROID_NDK_VERSION /opt/android-ndk && \
rm android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip

ENV ANDROID_NDK_HOME /opt/android-ndk

# Install Android tools
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager tools
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager platform-tools
RUN $ANDROID_HOME/tools/bin/sdkmanager platforms\;android-26

ENV GO_VERSION 1.9.2

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
ENV PATH $PATH:$ANDROID_NDK_HOME
ENV GOROOT /usr/local/go/go$GO_VERSION
ENV GOPATH /usr/local/go/

# Install go
RUN go get golang.org/x/mobile/cmd/gomobile

# Install Glide
ENV GLIDE_VERSION 0.13.1
RUN cd /tmp && \
curl -L https://github.com/Masterminds/glide/releases/download/v$GLIDE_VERSION/glide-v$GLIDE_VERSION-linux-amd64.tar.gz -o glide.tar.gz && \
tar -xf glide.tar.gz && \
mv linux-amd64/glide /usr/local/go/bin && \
rm glide.tar.gz

# Install Gradle
ENV GRADLE_VERSION 4.6
RUN cd /usr/local/ && \
wget https://downloads.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \
unzip gradle-$GRADLE_VERSION-bin.zip && \
mv gradle-$GRADLE_VERSION gradle && \
rm gradle-$GRADLE_VERSION-bin.zip
ENV GRADLE_HOME /usr/local/gradle-$GRADLE_VERSION
ENV PATH $PATH:/usr/local/gradle/bin
