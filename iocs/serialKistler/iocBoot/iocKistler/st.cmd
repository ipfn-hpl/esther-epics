#!../../bin/linux-x86_64/Kistler

#- You may have to change Kistler to something else
#- everywhere it appears in this file

< envPaths
epicsEnvSet( "STREAM_PROTOCOL_PATH", "$(TOP)/db" )
epicsEnvSet( "EPICS_CAS_INTF_ADDR_LIST", "192.168.0.98" )

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/Kistler.dbd"
Kistler_registerRecordDeviceDriver pdbbase

drvAsynSerialPortConfigure("KST1","/dev/ttyS0")
#
asynSetOption("KST1", 0, "baud", "115200")
asynSetOption("KST1", 0, "bits", "8")
asynSetOption("KST1", 0, "parity", "none")
asynSetOption("KST1", 0, "stop", "1")
asynSetOption("KST1", 0, "clocal", "Y")
asynSetOption("KST1", 0, "crtscts", "N")

drvAsynSerialPortConfigure ("PS1","/dev/ttyUSB0")
asynSetOption ("PS1", 0, "baud", "115200")
asynSetOption ("PS1", 0, "bits", "8")
asynSetOption ("PS1", 0, "parity", "none")
asynSetOption ("PS1", 0, "stop", "1")
asynSetOption ("PS1", 0, "clocal", "Y")
asynSetOption ("PS1", 0, "crtscts", "N")

## Load record instances
#dbLoadRecords("db/xxx.db","user=esther")
dbLoadRecords("db/kist.db","user=Esther:Camera")
dbLoadRecords "db/esp32BME680.db", "user=Esther:ambient, PORT=PS1"

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=esther"
