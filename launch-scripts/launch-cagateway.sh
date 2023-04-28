#!/bin/bash
# https://epics.anl.gov/EpicsDocumentation/ExtensionsManuals/Gateway/Gateway.html#Starting
EPICS_ROOT=/opt/epics
EPICS_BASE=${EPICS_ROOT}/epics-base
#EPICS_HOST_ARCH=`${EPICS_BASE}/startup/EpicsHostArch`
CA_GATE_BIN=${EPICS_ROOT}/extensions/ca-gateway/bin/linux-x86_64
MY_IP=$(/sbin/ip -o -4 addr list eno1 | awk '{print $4}' | cut -d/ -f1)
#MY_IP=$(/sbin/ip -o -4 addr list eth4 | awk '{print $4}' | cut -d/ -f1)
echo $MY_IP
#${CA_GATE_BIN}/gateway -log /tmp/gateway.log -cip 192.168.0.255 -sip ${MY_IP} -server  -archive -no_cache
${CA_GATE_BIN}/gateway -log /tmp/gateway.log -cip 192.168.0.255 -sip ${MY_IP} -sport 5064 -server
