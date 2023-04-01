#!../../bin/linux-arm/estherGas

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
# dbLoadRecords("db/S7sbits.db","user=Esther:gas, plc=myPLC")
dbLoadRecords("db/S7MFC.db","user=Esther:gas, plc=myPLC")
dbLoadRecords("db/S7PV70xAlarms.db","user=Esther:gas, plc=myPLC")


## Set this to see messages from mySub
#var mySubDebug 1

## Run this to trace the stages of iocInit
#traceIocInit

asSetFilename("/opt/epics/iocs/estherGas/access_critical.acf")

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncExample, "user=piHost"
