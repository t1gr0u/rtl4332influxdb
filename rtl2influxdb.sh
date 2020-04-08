#!/bin/sh

# A simple script that will collet events from an RTL433 SDR and send to InfluxDB

export LANG=C
PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

CONFIG_PATH=/data/options.json

INFLUXDB_HOST="$(jq --raw-output '.influxdb_host' $CONFIG_PATH)"
INFLUXDB_PORT="$(jq --raw-output '.influxdb_port' $CONFIG_PATH)"
INFLUXDB_USER="$(jq --raw-output '.influxdb_user' $CONFIG_PATH)"
INFLUXDB_PASS="$(jq --raw-output '.influxdb_password' $CONFIG_PATH)"
INFLUXDB_DB="$(jq --raw-output '.influxdb_database' $CONFIG_PATH)"
RTL_DEVICE_PROTOCOL="$(jq --raw-output '.rtl_device_protocol' $CONFIG_PATH)"

# Start rtl_433
echo "Starting RTL_433 with:"
echo "InfluxDB Host =" $INFLUXDB_HOST
echo "InfluxDB Port =" $INFLUXDB_PORT
echo "InfluxDB User =" $INFLUXDB_USER
echo "InfluxDB Password =" $INFLUXDB_PASS
echo "InfluxDB Database =" $INFLUXDB_DB
echo "RTL_433 Device Protocol =" $RTL_DEVICE_PROTOCOL

/usr/local/bin/rtl_433 -R $RTL_DEVICE_PROTOCOL -M time:unix:usec:utc -F "influx://${INFLUXDB_HOST}:${INFLUXDB_PORT}/write?db=${INFLUXDB_DB}&p=${INFLUXDB_PASS}&u=${INFLUXDB_USER}"

# rtl_433 -R 119 -F "influx://localhost:8086/write?db=<db>&p=<password>&u=<user>" -M time:unix:usec:utc
