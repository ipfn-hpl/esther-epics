#!/bin/bash
#https://epics.anl.gov/EpicsDocumentation/ExtensionsManuals/Gateway/Gateway.html#Starting
EPICS_ROOT=/opt/epics7
EPICS_BASE=${EPICS_ROOT}/epics-base
EPICS_HOST_ARCH=`${EPICS_BASE}/startup/EpicsHostArch`
CA_GATE_BIN=${EPICS_ROOT}/support/ca-gateway/bin/linux-x86_64
${CA_GATE_BIN}/gateway -log gateway.log -cip 192.168.0.60 -sip 10.10.136.73 -server  -archive -no_cache
