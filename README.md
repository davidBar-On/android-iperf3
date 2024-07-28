# android-iperf3

[![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/davidBar-On/android-iperf3/blob/master/LICENSE)

This repository is practically a copy of the [KnightWhoSayNi/android-iperf/](https://github.com/KnightWhoSayNi/android-iperf/) repository for iperf3 (but **not** iperf2), to continue building iperf3 for Android.  Note that this repository starts with iperf3 version 3.14, while the old repository stopped at version 3.10.1.

## Getting Started

**What is iPerf3** ?

iPerf3 is a tool for active measurements of the maximum achievable bandwidth on IP networks. It supports tuning of various parameters related to timing, buffers and protocols (TCP, UDP, SCTP with IPv4 and IPv6). For each test it reports the bandwidth, loss, and other parameters.

For more informatiion, see [https://github.com/esnet/iperf](https://github.com/esnet/iperf), which also includes the iperf3 source code (note that this repository does not include any iperf3 source code).

### Supported versions

| Version        | Release day           | Source Code  |
| :-------------: |:-------------:|:-------------:|
| `3.13-mt-beta3` | 2023-05-17 | [Source Code](https://downloads.es.net/pub/iperf/iperf-3.13-mt-beta3.tar.gz)  |
| `3.14`          | 2023-07-07 | [Source Code](https://downloads.es.net/pub/iperf/iperf-3.14.tar.gz)  |
| `3.15`          | 2023-09-27 | [Source Code](https://downloads.es.net/pub/iperf/iperf-3.15.tar.gz)  |
| `3.16-beta1`    | 2023-11-15 | [Source Code](https://downloads.es.net/pub/iperf/iperf-3.16-beta1.tar.gz)  |
| `3.16`          | 2023-12-01 | [Source Code](https://downloads.es.net/pub/iperf/iperf-3.16.tar.gz)  |
| `3.17.1`        | 2024-05-13 | [Source Code](https://downloads.es.net/pub/iperf/iperf-3.17.1.tar.gz)  |

### Download

Compiled `iperf3` binaries using SDK `9477386_latest` and NDK `r22` for devices with Android `9.0+` (API level `28+`).

| ABI        | Binaries           |
| ------------- |:-------------:|
| arm64-v8a     | [here](https://github.com/davidBar-On/android-iperf3/tree/gh-pages/libs/arm64-v8a) |
| armeabi-v7a      | [here](https://github.com/davidBar-On/android-iperf3/tree/gh-pages/libs/armeabi-v7a)      |
| x86 | [here](https://github.com/davidBar-On/android-iperf3/tree/gh-pages/libs/x86)     |
| x86_64 | [here](https://github.com/davidBar-On/android-iperf3/tree/gh-pages/libs/x86_64)     |

More about *Application Binary Interface* (ABI): [https://developer.android.com/ndk/guides/abis](https://developer.android.com/ndk/guides/abis)

To get supported ABI by an Android device:

```shell
adb shell getprop ro.product.cpu.abilist
```

## Build

### Prerequisites

Docker

### Running

1. Clone this repo
2. Build image from Dockerfile

```shell
docker build -t android-ndk:latest .
```

3. Run container and fetch binaries

```shell
docker run -d --name android-ndk-container android-ndk
mkdir -p binaries
docker cp -a android-ndk-container:/tmp/libs binaries
docker stop android-ndk-container
docker rm android-ndk-container
```

## Usage

Upload a binary file (with compatible ABI) to an Android device

```shell
adb push <LOCAL_PATH_TO_BINARY_FILE>/<BINARY_NAME> /data/local/tmp/<BINARY_NAME>
adb shell chmod 777 /data/local/tmp/<BINARY_NAME>
```

Set a default `iperf3`
```shell
adb shell ln -s /data/local/tmp/<IPERF3_BINARY_NAME> iperf3
```

Execute `iperf3`
```shell
adb shell /data/local/tmp/iperf3 <IPERF_ARGUMENTS>
```

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


## Acknowledgments

[KnightWhoSayNi](https://github.com/KnightWhoSayNi/android-iperf/)
