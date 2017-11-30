FROM ubuntu:16.04
MAINTAINER Ulysses Aalto <uaalto@getlantern.org>

RUN apt-get update

# Install Java RUN apt-get install -y openjdk-7-jre
RUN apt-get install -y apt-utils
RUN apt-get install -y openjdk-8-jdk curl wget unzip build-essential git

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

RUN cd /usr/local && \
wget --show-progress https://dl.google.com/android/repository/android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip

RUN cd /usr/local/ && \
unzip android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip && \
rm android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip

ENV ANDROID_NDK_HOME /usr/local/android-ndk-$ANDROID_NDK_VERSION

# Install Android tools
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager tools
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager platform-tools
RUN $ANDROID_HOME/tools/bin/sdkmanager platforms\;android-26

RUN cd /usr/local/ && \
wget https://redirector.gvt1.com/edgedl/go/go1.9.2.linux-amd64.tar.gz && \
tar xvf go1.9.2.linux-amd64.tar.gz && \
rm go1.9.2.linux-amd64.tar.gz

# Install Gradle
RUN cd /usr/local/ && \
wget https://github.com/gradle/gradle/archive/v4.4.0-RC1.zip && \
unzip v4.4.0-RC1.zip

# Environment variables
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV GRADLE_HOME /usr/local/gradle-4.4.0-RC1
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools
ENV PATH $PATH:$GRADLE_HOME/bin
ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH /usr/local/go
