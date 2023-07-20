FROM ubuntu:22.04
LABEL maintainer="david.cdb004@gmail.com"

RUN apt-get -y update -qq
RUN    apt-get -y upgrade -qq
RUN    apt-get -y install -qq make bash git unzip wget curl openjdk-17-jdk build-essential autoconf nano tree
RUN    apt-get clean
RUN    rm -rf /var/lib/apt/lists/*

ARG API_VERSION=26
ARG SDK_VERSION=9477386_latest
ARG NDK_VERSION=r22

ENV ANDROID_SDK_VERSION ${SDK_VERSION}
ENV ANDROID_SDK_HOME /opt/android-sdk
ENV ANDROID_SDK_FILENAME commandlinetools-linux-${ANDROID_SDK_VERSION}
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/${ANDROID_SDK_FILENAME}.zip

RUN wget --no-check-certificate -q ${ANDROID_SDK_URL} && \
    mkdir -p ${ANDROID_SDK_HOME} && \
    unzip -q ${ANDROID_SDK_FILENAME}.zip -d ${ANDROID_SDK_HOME} && \
    rm -f ${ANDROID_SDK_FILENAME}.zip

ENV PATH=${PATH}:${ANDROID_SDK_HOME}/cmdline-tools/bin

RUN yes | sdkmanager --sdk_root=${ANDROID_SDK_HOME} --licenses > /dev/null
RUN    yes | sdkmanager --sdk_root=${ANDROID_SDK_HOME} "platforms;android-${API_VERSION}" > /dev/null

ENV ANDROID_NDK_VERSION ${NDK_VERSION}
ENV ANDROID_NDK_HOME /opt/android-ndk
ENV ANDROID_NDK_FILENAME android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64
ENV ANDROID_NDK_URL https://dl.google.com/android/repository/${ANDROID_NDK_FILENAME}.zip

RUN wget --no-check-certificate -q ${ANDROID_NDK_URL} && \
    mkdir -p ${ANDROID_NDK_HOME} && \
    unzip -q ${ANDROID_NDK_FILENAME}.zip && \
    mv ./android-ndk-${ANDROID_NDK_VERSION}/* ${ANDROID_NDK_HOME} && \
    rm -f ${ANDROID_NDK_FILENAME}.zip

ENV PATH=${PATH}:${ANDROID_NDK_HOME}

ENV NDK_PROJECT_PATH=/tmp

# Config files

RUN mkdir -p /tmp/jni
COPY /jni/Android.mk /tmp/jni
COPY /jni/Application.mk /tmp/jni

#####################
# iPerf 3.13-mt-beta3
#####################

RUN cd /tmp && \
    wget --no-check-certificate -q https://downloads.es.net/pub/iperf/iperf-3.13-mt-beta3.tar.gz && \
    tar -zxvf iperf-3.13-mt-beta3.tar.gz && \
    rm -f iperf-3.13-mt-beta3.tar.gz

COPY /iperf-3.13-mt-beta3/* /tmp/iperf-3.13-mt-beta3/

# Workaround for pthread_cancel() as it is not supported by Android NDK
COPY /iperf-3.13-mt-beta3/iperf3-pthread.h /tmp/iperf-3.13-mt-beta3/src/pthread.h
COPY /iperf-3.13-mt-beta3/iperf3-pthread.c /tmp/iperf-3.13-mt-beta3/src/
RUN cd /tmp/iperf-3.13-mt-beta3 && \
    sed 's/#include <pthread.h>/#include \"pthread.h\"/' src/iperf.h > src/tmp_iperf.h && \
    cp src/tmp_iperf.h src/iperf.h

RUN cd /tmp/iperf-3.13-mt-beta3 && \
    ./configure

############
# iPerf 3.14
############

RUN cd /tmp && \
    wget --no-check-certificate -q https://downloads.es.net/pub/iperf/iperf-3.14.tar.gz && \
    tar -zxvf iperf-3.14.tar.gz && \
    rm -f iperf-3.14.tar.gz

COPY /iperf-3.14/* /tmp/iperf-3.14/
RUN cd /tmp/iperf-3.14 && \
    ./configure

# Compile

RUN ndk-build clean

RUN ndk-build NDK_APPLICATION_MK=/tmp/jni/Application.mk

RUN tree /tmp/libs
