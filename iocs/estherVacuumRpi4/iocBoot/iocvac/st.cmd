#!../../bin/linux-aarch64/vac

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
# dbLoadRecords "db/vacVersion.db", "user=pi"

# Arduino MST12 ARM control CTST
# /dev/ttyACM0
drvAsynSerialPortConfigure("RS232A1","/dev/armCTST")
asynSetOption("RS232A1", 0, "baud", "115200")
asynSetOption("RS232A1", 0, "bits", "8")
asynSetOption("RS232A1", 0, "parity", "none")
asynSetOption("RS232A1", 0, "stop", "1")
dbLoadRecords("db/armcontrol.db", "P=Esther:,R=ARM:,A=1")

# Arduino MST12 ARM control
drvAsynSerialPortConfigure("RS232A2","/dev/armSTDT")
asynSetOption("RS232A2", 0, "baud", "115200")
asynSetOption("RS232A2", 0, "bits", "8")
asynSetOption("RS232A2", 0, "parity", "none")
asynSetOption("RS232A2", 0, "stop", "1")
dbLoadRecords("db/armcontrol.db", "P=Esther:,R=ARM:,A=2")

epicsEnvSet "A" "$(A=3)"
epicsEnvSet "BRS" "$(BRS=RS232A$(A))"
## Arduino HVA Gate Valve control
drvAsynSerialPortConfigure("$(BRS)","/dev/gatevalveCTST",0,0,0)
asynSetOption("$(BRS)", 0, "baud", "115200")
asynSetOption("$(BRS)", 0, "bits", "8")
asynSetOption("$(BRS)", 0, "parity", "none")
asynSetOption("$(BRS)", 0, "stop", "1")
dbLoadRecords("db/armcontrol.db", "P=$(P):,R=HVA:,A=3")

## EDWARDS SCU 800
## Load Serial drivers
drvAsynSerialPortConfigure("RS485","/dev/rs485")
asynSetOption("RS485", 0, "baud", "38400")
asynSetOption("RS485", 0, "bits", "8")
asynSetOption("RS485", 0, "parity", "none")
asynSetOption("RS485", 0, "stop", "1")
#asynSetOption("RS485", 0, "clocal", "Y")
#asynSetOption("RS485", 0, "crtscts", "N")
## Load record instances
dbLoadRecords("db/edwards.db", "P=Esther:,R=EDW:,BUS=RS485")

## EDWARDS ADC Vacuum Monitor
drvAsynSerialPortConfigure("RS232E1","/dev/edwardsADC")
asynSetOption("RS232E1", 0, "baud", "9600")
asynSetOption("RS232E1", 0, "bits", "8")
asynSetOption("RS232E1", 0, "parity", "none")
asynSetOption("RS232E1", 0, "stop", "1")
#asynSetOption("RS232E1", 0, "clocal", "Y")
##asynSetOption("RS232E1", 0, "crtscts", "N")
dbLoadRecords("db/edwards-adc.db", "P=Esther:,R=Vacuum:,A=1,BUS=RS232E1")

#- Set this to see messages from mySub
#var mySubDebug 1

#- Run this to trace the stages of iocInit
#traceIocInit

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
seq sncEstherVacuum, "user=pi,unit=Esther"

