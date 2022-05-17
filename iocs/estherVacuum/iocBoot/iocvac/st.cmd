#!../../bin/linux-x86_64/vac

#- You may have to change vac to something else
#- everywhere it appears in this file

< envPaths

epicsEnvSet( "STREAM_PROTOCOL_PATH", "$(TOP)/db" )
epicsEnvSet "P" "$(P=Esther)"
epicsEnvSet "BH3" "$(BH3=RS232AB3)"

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/vac.dbd"
vac_registerRecordDeviceDriver pdbbase

## EDWARDS SCU 800
#drvAsynSerialPortConfigure("RS485","/dev/ttyUSB2")
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

## EDWARDS ADCa (Now on Raspberry rpi-vacuum)
#drvAsynSerialPortConfigure("RS232E1","/dev/edwardsADC")
#asynSetOption("RS232E1", 0, "baud", "9600")
#asynSetOption("RS232E1", 0, "bits", "8")
#asynSetOption("RS232E1", 0, "parity", "none")
#asynSetOption("RS232E1", 0, "stop", "1")
##asynSetOption("RS232E1", 0, "clocal", "Y")
##asynSetOption("RS232E1", 0, "crtscts", "N")
#dbLoadRecords("db/edwards-adc.db", "P=Esther:,R=Vacuum:,A=1,BUS=RS232E1")

# Arduino MST12 ARM control CTST
# /dev/ttyACM0
#drvAsynSerialPortConfigure("RS232A1","/dev/armCTST")
#asynSetOption("RS232A1", 0, "baud", "115200")
#asynSetOption("RS232A1", 0, "bits", "8")
#asynSetOption("RS232A1", 0, "parity", "none")
#asynSetOption("RS232A1", 0, "stop", "1")
#dbLoadRecords("db/armcontrol.db", "P=Esther:,R=ARM:,A=1")

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

## Arduino Gate Valve  control
epicsEnvSet "E" "$(E=4)"
epicsEnvSet "BRE" "$(BRE=RS232A$(E))"
## Arduino HVA Gate Valve control
drvAsynSerialPortConfigure("$(BRE)","/dev/gatevalveSTDT",0,0,0)
asynSetOption("$(BRE)", 0, "baud", "115200")
asynSetOption("$(BRE)", 0, "bits", "8")
asynSetOption("$(BRE)", 0, "parity", "none")
asynSetOption("$(BRE)", 0, "stop", "1")
dbLoadRecords("db/armcontrol.db", "P=$(P):,R=HVA:,A=$(E)")

## Arduino BME680 Air quality sensor
#epicsEnvSet("F", "5")
#epicsEnvSet("BRF", "RS232A$(F)")
## Arduino HVA Gate Valve control
#drvAsynSerialPortConfigure("$(BRF)","/dev/ttyUSB0",0,0,0)
#asynSetOption("$(BRF)", 0, "baud", "230400")
#asynSetOption("$(BRF)", 0, "bits", "8")
#asynSetOption("$(BRF)", 0, "parity", "none")
#asynSetOption("$(BRF)", 0, "stop", "1")
#dbLoadRecords("db/bme680.db", "P=$(P):,R=BME:,A=$(F)")

var streamError 1
#var streamDebug 1
#streamSetLogfile("stream_logfile.txt")

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=bernardo"
