#!../../bin/linux-x86_64/vac

#- You may have to change vac to something else
#- everywhere it appears in this file

< envPaths

epicsEnvSet("STREAM_PROTOCOL_PATH", "$(TOP)/db")
cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/vac.dbd"
vac_registerRecordDeviceDriver pdbbase

## Load record instances
drvAsynSerialPortConfigure("RS232INF","/dev/tty_inficon")
asynSetOption("RS232INF", 0, "baud", "19200")
asynSetOption("RS232INF", 0, "bits", "8")
asynSetOption("RS232INF", 0, "parity", "none")
asynSetOption("RS232INF", 0, "stop", "1")
dbLoadRecords("db/inficonVG401.db", "P=Esther:,R=Vacuum:,BUS=RS232INF")


cd "${TOP}/iocBoot/${IOC}"
iocInit

var streamError 1
var streamDebug 0
var streamDebugColored 1
var streamErrorDeadTime 30
var streamMsgTimeStamped 1
streamSetLogfile("logfile.txt")

## Start any sequence programs
#seq sncxxx,"user=esther"
