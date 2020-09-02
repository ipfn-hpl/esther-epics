#!./bin/linux-arm/estherGas
#Tested on 
# Linux raspberrypi 4.19.66-v7+ 
# linux-arm kernel 3.18.7-v7+
#
#s7nodave-2.1.3
#asyn4-35
#epics base-3.15.6

## You may have to change estherGas to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/estherGas.dbd"
estherGas_registerRecordDeviceDriver pdbbase

#Configure PLC Connection
s7nodaveConfigureIsoTcpPort("myPLC", "192.168.0.2", 0)
 
# Configure Poll Group
s7nodaveConfigurePollGroup("myPLC", "default", 1.0, 0)
s7nodaveConfigurePollGroup("myPLC", "fast", 0.1, 0)

## Load record instances
dbLoadRecords("db/S7Tags.db","user=Esther:gas")
dbLoadRecords("db/S7PT.db","user=Esther:gas")
dbLoadRecords("db/S7PTAlarms.db","user=Esther:gas")
dbLoadRecords("db/S7PV.db","user=Esther:gas")
dbLoadRecords("db/S7PV_out.db","user=Esther:gas")
dbLoadRecords("db/S7sbits.db","user=Esther:gas, plc=myPLC")
dbLoadRecords("db/S7MFC.db","user=Esther:gas, plc=myPLC")
dbLoadRecords("db/S7PV70xAlarms.db","user=Esther:gas, plc=myPLC")

asSetFilename("/opt/epics/iocs/estherGas/access_critical.acf")

#cd ${TOP}/iocBoot/${IOC}
#cd ${TOP}
iocInit

#IOC access security
asInit

## Start any sequence programs
#seq sncxxx,"user=bernardoHost"
