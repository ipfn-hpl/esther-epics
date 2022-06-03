#!../../bin/linux-arm/vac

#- You may have to change vac to something else
#- everywhere it appears in this file

< envPaths

epicsEnvSet( "STREAM_PROTOCOL_PATH", "$(TOP)/db" )
epicsEnvSet "P" "$(P=Esther)"

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/vac.dbd"
vac_registerRecordDeviceDriver pdbbase

## Load record instances
#dbLoadTemplate "db/user.substitutions"
dbLoadRecords "db/vacVersion.db", "user=pi"
#dbLoadRecords "db/dbSubExample.db", "user=pi"

## EDWARDS ADC
#drvAsynSerialPortConfigure("RS232E1","/dev/edwardsADC")
#asynSetOption("RS232E1", 0, "baud", "9600")
#asynSetOption("RS232E1", 0, "bits", "8")
#asynSetOption("RS232E1", 0, "parity", "none")
#asynSetOption("RS232E1", 0, "stop", "1")
##asynSetOption("RS232E1", 0, "clocal", "Y")
##asynSetOption("RS232E1", 0, "crtscts", "N")
#dbLoadRecords("db/edwards-adc.db", "P=Esther:,R=Vacuum:,A=1,BUS=RS232E1")

dbLoadRecords("db/estherStates.db", "P=Esther:,R=Vacuum:")

#- Set this to see messages from mySub
#var mySubDebug 1

#- Run this to trace the stages of iocInit
#traceIocInit

var streamError 1
#var streamDebug 1
#streamSetLogfile("stream_logfile.txt")

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
seq sncEstherVacuum, "user=pi"
