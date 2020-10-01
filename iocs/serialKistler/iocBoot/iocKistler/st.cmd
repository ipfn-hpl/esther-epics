#!../../bin/linux-x86_64/Kistler

#- You may have to change Kistler to something else
#- everywhere it appears in this file

< envPaths
epicsEnvSet( "STREAM_PROTOCOL_PATH", "$(TOP)/db" )

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/Kistler.dbd"
Kistler_registerRecordDeviceDriver pdbbase

drvAsynSerialPortConfigure("KST1","/dev/ttyUSB0")
#
asynSetOption("KST1", 0, "baud", "115200")
asynSetOption("KST1", 0, "bits", "8")
asynSetOption("KST1", 0, "parity", "none")
asynSetOption("KST1", 0, "stop", "1")
asynSetOption("KST1", 0, "clocal", "Y")
asynSetOption("KST1", 0, "crtscts", "N")
## Load record instances
#dbLoadRecords("db/xxx.db","user=esther")
dbLoadRecords("db/kist.db","user=Esther:Camera")

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=esther"
