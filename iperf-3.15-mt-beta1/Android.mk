LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := iperf3.15-mt-beta1
LOCAL_MODULE_TAGS := dev
LOCAL_CFLAGS := -DHAVE_CONFIG_H -UAF_INET6 -w -Wno-error=format-security
LOCAL_LDFLAGS := -fPIE -pie
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_SRC_FILES := \
		src/cjson.c \
		src/dscp.c \
		src/iperf_api.c \
		src/iperf_auth.c \
		src/iperf_client_api.c \
		src/iperf_error.c \
		src/iperf_locale.c \
		src/iperf_sctp.c \
		src/iperf_server_api.c \
		src/iperf_tcp.c \
		src/iperf_time.c \
		src/iperf_udp.c \
		src/iperf_util.c \
		src/main.c \
		src/net.c \
		src/tcp_info.c \
		src/timer.c \
		src/units.c \
		src/iperf3-pthread.c \

LOCAL_DISABLE_FORMAT_STRING_CHECKS := true
include $(BUILD_EXECUTABLE)
