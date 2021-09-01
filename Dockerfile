FROM ubuntu:20.04

RUN apt-get update \
&& apt-get install -y apt-utils \
&& apt-get install -y curl \
&& apt-get install -y ant \
&& apt-get install -y zip unzip \
&& apt-get install -y cmake \
&& apt-get install -y g++ \
&& apt-get install -y git 

#Java 7, 8 install
RUN apt-get install software-properties-common --yes

RUN add-apt-repository ppa:openjdk-r/ppa --yes
RUN apt-get update
RUN apt-get install openjdk-8-jdk --yes
RUN apt-get install openjdk-8-jre --yes

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip" \
    NDK_URL="https://dl.google.com/android/repository/android-ndk-r21e-linux-x86_64.zip" \
    ANDROID_SDK_HOME="/opt/android-sdk" \
    ANDROID_NDK_HOME="/opt/android-ndk" \
    ANDROID_VERSION=29 \
    ANDROID_BUILD_TOOLS_VERSION=30.0.2 \
    PATH=/opt/android-ndk/android-ndk-r21:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/android-ndk:/opt/android-sdk/cmdline-tools/latest/:/opt/android-sdk/cmdline-tools/latest/bin/

RUN	mkdir $ANDROID_SDK_HOME \
    && cd $ANDROID_SDK_HOME \
    && mkdir ./tmp \
    && cd ./tmp \
    && curl -o sdk.zip $SDK_URL \
    && unzip sdk.zip \
    && rm sdk.zip \
    && cd .. \
    && mkdir $ANDROID_SDK_HOME/cmdline-tools/ \
    && mkdir $ANDROID_SDK_HOME/cmdline-tools/latest \
    && mv -v $ANDROID_SDK_HOME/tmp/cmdline-tools/* $ANDROID_SDK_HOME/cmdline-tools/latest/ \
    && rm -r ./tmp

# Install Android Build Tool and Libraries
RUN $ANDROID_SDK_HOME/cmdline-tools/latest/bin/sdkmanager --update
RUN $ANDROID_SDK_HOME/cmdline-tools/latest/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"

#Install Android NDK
RUN mkdir $ANDROID_NDK_HOME \
    && cd $ANDROID_NDK_HOME \
	&& curl -o ndk.zip $NDK_URL \
	&& unzip ndk.zip \
	&& rm ndk.zip \
	&& mv -v $ANDROID_NDK_HOME/android-ndk-r21e/* $ANDROID_NDK_HOME/

WORKDIR /tmp/app