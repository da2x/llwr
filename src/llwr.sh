#!/bin/env bash

COMMAND_ARG="$@"
if [ -z "$COMMAND_ARG" -o "$COMMAND_ARG" == " " ]; then
  >&2 echo "Usage: $0 [COMMAND_ARG] [ARG]...]"
  exit 1
fi

WIFI_IFACES=`grep -Eo '^[[:alnum:]]+\:' /proc/net/wireless | cut -d: -f1 | xargs`
if [ -z "$WIFI_IFACES" -o "$WIFI_IFACES" == " " ]; then
  >&2 echo "WARN: No wireless interfaces recognized."
  $COMMAND_ARG
  exit 0
fi

function power_savings_off {
  for IFACE in $WIFI_IFACES; do
    /bin/env iw dev ${IFACE} set power_save off 1> /dev/null
  done
}
function power_savings_on  {
  for IFACE in $WIFI_IFACES; do
    /bin/env iw dev ${IFACE} set power_save on  1> /dev/null
  done
}
function power_savings_state {
  for IFACE in $WIFI_IFACES; do
    if [ "$WIFI_DPSM" != "on" ]; then
      WIFI_DPSM=`/bin/env iw dev ${IFACE} get power_save | \
      grep -Eo 'Power save: o(n|ff)' | cut -f3 -d\ `
    fi
  done
}

WIFI_DPSM="off"
power_savings_state

# main
if [ "$WIFI_DPSM" == "on" ]; then
  power_savings_off
fi

$COMMAND_ARG

if [ "$WIFI_DPSM" == "on" ]; then
  power_savings_on
fi

