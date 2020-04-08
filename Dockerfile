# Docker file to create an image for a Home Assistant add-on that contains enough software to listen to events via RTL_SDR/RTL_433 and sends it to the InfluxDB.

# IMPORTANT: The container needs privileged access to /dev/bus/usb on the host.

ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

LABEL Description="This image is used to start a script that will monitor for RF events on 433Mhz (configurable) and send the data to an MQTT server"

#
# Install and compile software packages needed for rtl_433
#
RUN apk add --no-cache --virtual build-deps alpine-sdk cmake git libusb-dev && \
    mkdir /tmp/src && \
    cd /tmp/src && \
    git clone git://git.osmocom.org/rtl-sdr.git && \
    mkdir /tmp/src/rtl-sdr/build && \
    cd /tmp/src/rtl-sdr/build && \
    cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON -DCMAKE_INSTALL_PREFIX:PATH=/usr/local && \
    make && \
    make install && \
    chmod +s /usr/local/bin/rtl_* && \
    cd /tmp/src/ && \
    git clone https://github.com/merbanan/rtl_433 && \
    cd rtl_433/ && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    make && \
    make install && \
    apk del build-deps && \
    rm -r /tmp/src && \
    apk add --no-cache libusb jq

#
# Define an environment variable
#
# Use this variable when creating a container to specify the InfluxDB.
ENV INFLUXDB_HOST="a0d7b954-influxdb"
ENV INFLUXDB_PORT="8086"
ENV INFLUXDB_USER="guest"
ENV INFLUXDB_PASS="guest"
ENV INFLUXDB_DB="rtl433"

CMD /config/rtl4332influxdb/rtl2influxdb.sh
