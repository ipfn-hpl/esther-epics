#!../../bin/linux-aarch64/gas

#- SPDX-FileCopyrightText: 2003 Argonne National Laboratory
#-
#- SPDX-License-Identifier: EPICS

#- You may have to change gas to something else
#- everywhere it appears in this file

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/gas.dbd"
gas_registerRecordDeviceDriver pdbbase

## OAUPC Pretty minimal setup: one session with a 200ms subscription on top
opcuaSession OPC1 opc.tcp://192.168.0.2:4840
opcuaSubscription OPC_SUB1 OPC1 200

# Switch off security
opcuaOptions OPC1 sec-mode=None

## Load record instances
dbLoadRecords("db/S7-opcua-PT.db", "P=Esther:,R=Gas-Opc:,SUBS=OPC_SUB1")
dbLoadRecords("db/S7-opcua-PT-low.db", "P=Esther:,R=Gas-Opc:,SUBS=OPC_SUB1")
dbLoadRecords("db/S7-opcua-PV.db", "P=Esther:,R=Gas-Opc:,SUBS=OPC_SUB1")
dbLoadRecords("db/S7-opcua-PV-master.db", "P=Esther:,R=Gas-Opc:,SUBS=OPC_SUB1")
# dbLoadRecords("db/gas.db","user=esther")


cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=esther"
