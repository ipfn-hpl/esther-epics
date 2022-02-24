#!../../bin/linux-x86_64/vac

#- You may have to change vac to something else
#- everywhere it appears in this file

< envPaths

epicsEnvSet( "STREAM_PROTOCOL_PATH", "$(TOP)/db" )

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/vac.dbd"
vac_registerRecordDeviceDriver pdbbase

## EDWARDS SCU 800
## Load Serial drivers
drvAsynSerialPortConfigure("RS485","/dev/rs485")
#drvAsynSerialPortConfigure("RS485","/dev/ttyUSB2")
asynSetOption("RS485", 0, "baud", "38400")
asynSetOption("RS485", 0, "bits", "8")
asynSetOption("RS485", 0, "parity", "none")
asynSetOption("RS485", 0, "stop", "1")
#asynSetOption("RS485", 0, "clocal", "Y")
#asynSetOption("RS485", 0, "crtscts", "N")

## Load record instances
#dbLoadRecords("db/xxx.db","user=bernardo")

dbLoadRecords("db/edwards.db", "P=Esther:,R=EDW:,BUS=RS485")

## EDWARDS ADC 
drvAsynSerialPortConfigure("RS232E1","/dev/edwardsADC")
##drvAsynSerialPortConfigure("RS232E1","/dev/ttyUSB1")
asynSetOption("RS232E1", 0, "baud", "9600")
asynSetOption("RS232E1", 0, "bits", "8")
asynSetOption("RS232E1", 0, "parity", "none")
asynSetOption("RS232E1", 0, "stop", "1")
##asynSetOption("RS232E1", 0, "clocal", "Y")
##asynSetOption("RS232E1", 0, "crtscts", "N")

dbLoadRecords("db/edwards-adc.db", "P=Esther:,R=Vacuum:,A=1,BUS=RS232E1")

drvAsynSerialPortConfigure("RS232A1","/dev/armCTST")
asynSetOption("RS232A1", 0, "baud", "115200")
asynSetOption("RS232A1", 0, "bits", "8")
asynSetOption("RS232A1", 0, "parity", "none")
asynSetOption("RS232A1", 0, "stop", "1")

#dbLoadRecords("db/armcontrol.db", "P=Esther:,R=ARM:,A=1,BUS=RS232A1")
dbLoadRecords("db/armcontrol.db", "P=Esther:,R=ARM:,A=1")

drvAsynSerialPortConfigure("RS232A2","/dev/armSTDT")
asynSetOption("RS232A2", 0, "baud", "115200")
asynSetOption("RS232A2", 0, "bits", "8")
asynSetOption("RS232A2", 0, "parity", "none")
asynSetOption("RS232A2", 0, "stop", "1")

dbLoadRecords("db/armcontrol.db", "P=Esther:,R=ARM:,A=2")


var streamError 1
#var streamDebug 1
#streamSetLogfile("stream_logfile.txt")

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=bernardo"
