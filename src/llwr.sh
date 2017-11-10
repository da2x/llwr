#
# Copyright © 2016–2017 Daniel Aleksandersen
# SPDX-License-Identifier: MIT
# License-Filename: LICENSE
#

#!/bin/env bash

CUT_CMD="/bin/env cut"
GREP_CMD="/bin/env grep"
IW_CMD="/bin/env iw"
XARGS_CMD="/bin/env xargs"

COMMAND_ARG="$@"
if [ -z "$COMMAND_ARG" -o "$COMMAND_ARG" == " " ]; then
  >&2 echo "Usage: $0 [COMMAND_ARG] [ARG]...]"
  exit 1
fi

WIFI_IFACES=`${GREP_CMD} -Eo '^[[:alnum:]]+\:' /proc/net/wireless | ${CUT_CMD} -d: -f1 | ${XARGS_CMD}`
if [ -z "$WIFI_IFACES" -o "$WIFI_IFACES" == " " ]; then
  >&2 echo "WARN: No wireless interfaces recognized."
  $COMMAND_ARG
  exit 0
fi

function power_savings_off {
  for IFACE in $WIFI_IFACES; do
    ${IW_CMD} dev ${IFACE} set power_save off 1> /dev/null
  done
}
function power_savings_on  {
  for IFACE in $WIFI_IFACES; do
    ${IW_CMD} dev ${IFACE} set power_save on  1> /dev/null
  done
}
function power_savings_state {
  for IFACE in $WIFI_IFACES; do
    if [ "$WIFI_DPSM" != "on" ]; then
      WIFI_DPSM=`${IW_CMD} dev ${IFACE} get power_save | \
      ${GREP_CMD} -Eo 'Power save: o(n|ff)' | ${CUT_CMD} -f3 -d\ `
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

