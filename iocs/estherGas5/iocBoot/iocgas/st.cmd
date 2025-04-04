#!../../bin/linux-aarch64/gas

#- SPDX-FileCopyrightText: 2003 Argonne National Laboratory
#-
#- SPDX-License-Identifier: EPICS

#- You may have to change gas to something else
#- everywhere it appears in this file

< envPaths
epicsEnvSet("STREAM_PROTOCOL_PATH", "$(TOP)/db")


cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/gas.dbd"
gas_registerRecordDeviceDriver pdbbase

## OAUPC Pretty minimal setup: one session with a 200ms subscription on top
opcuaSession OPC1 opc.tcp://192.168.0.2:4840
opcuaSubscription OPC_SUB1 OPC1 200

opcuaSession OPC2 opc.tcp://192.168.0.2:4840
opcuaSubscription OPC_SUB2 OPC2 100

# Switch off security
opcuaOptions OPC1 sec-mode=None
opcuaOptions OPC2 sec-mode=None

## Load record instances
dbLoadRecords("db/S7-opcua-PT.db", "P=Esther:,R=Gas-Opc:,SUBS=OPC_SUB2")
dbLoadRecords("db/S7-opcua-Alarms.db", "P=Esther:,R=Gas-Opc:,SUBS=OPC_SUB1")
dbLoadRecords("db/S7-opcua-PT-sp.db", "P=Esther:,R=Gas-Opc:,SUBS=OPC_SUB1")
dbLoadRecords("db/S7-opcua-PV.db", "P=Esther:,R=Gas-Opc:,SUBS=OPC_SUB1")
dbLoadRecords("db/S7-opcua-PV-master.db", "P=Esther:,R=Gas-Opc:,SUBS=OPC_SUB1")
dbLoadRecords("db/S7-opcua-MFC.db", "P=Esther:,R=Gas-Opc:,SUBS=OPC_SUB1")
dbLoadRecords("db/S7-opcua-Control.db", "P=Esther:,R=Gas-Opc:,SUBS=OPC_SUB1")

# dbLoadRecords("db/gas.db","user=esther")

# NA111 Ethernet <->RS485
drvAsynIPPortConfigure("LAN","192.168.0.31:8887",0,0,0)
dbLoadRecords("db/nWRG.db", "P=Esther:,R=Gas-Opc:,PORT=LAN,A=0")

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=esther"
