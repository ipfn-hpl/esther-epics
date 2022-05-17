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
#dbLoadRecords("db/xxx.db","user=pi")

## EDWARDS ADC
drvAsynSerialPortConfigure("RS232E1","/dev/edwardsADC")
asynSetOption("RS232E1", 0, "baud", "9600")
asynSetOption("RS232E1", 0, "bits", "8")
asynSetOption("RS232E1", 0, "parity", "none")
asynSetOption("RS232E1", 0, "stop", "1")
##asynSetOption("RS232E1", 0, "clocal", "Y")
##asynSetOption("RS232E1", 0, "crtscts", "N")
dbLoadRecords("db/edwards-adc.db", "P=Esther:,R=Vacuum:,A=1,BUS=RS232E1")

# Arduino MST12 ARM control CTST
#drvAsynSerialPortConfigure("RS232A1","/dev/armCTST")
drvAsynSerialPortConfigure("RS232A1","/dev/ttyACM0")
asynSetOption("RS232A1", 0, "baud", "115200")
asynSetOption("RS232A1", 0, "bits", "8")
asynSetOption("RS232A1", 0, "parity", "none")
asynSetOption("RS232A1", 0, "stop", "1")
dbLoadRecords("db/armcontrol.db", "P=Esther:,R=ARM:,A=1")

# No power on Raspberry USB for SeeduinoV4.2
#epicsEnvSet "A" "$(A=3)"
#epicsEnvSet "BRS" "$(BRS=RS232A$(A))"
## Arduino HVA Gate Valve control
#drvAsynSerialPortConfigure("$(BRS)","/dev/gatevalveCTST",0,0,0)
#asynSetOption("$(BRS)", 0, "baud", "115200")
#asynSetOption("$(BRS)", 0, "bits", "8")
#asynSetOption("$(BRS)", 0, "parity", "none")
#asynSetOption("$(BRS)", 0, "stop", "1")
#dbLoadRecords("db/armcontrol.db", "P=$(P):,R=HVA:,A=3")

## Arduino Gate Valve  control
#epicsEnvSet "E" "$(E=4)"
#epicsEnvSet "BRE" "$(BRE=RS232A$(E))"
## Arduino HVA Gate Valve control
#drvAsynSerialPortConfigure("$(BRE)","/dev/gatevalveSTDT",0,0,0)
#asynSetOption("$(BRE)", 0, "baud", "115200")
#asynSetOption("$(BRE)", 0, "bits", "8")
#asynSetOption("$(BRE)", 0, "parity", "none")
#asynSetOption("$(BRE)", 0, "stop", "1")
#dbLoadRecords("db/armcontrol.db", "P=$(P):,R=HVA:,A=$(E)")

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=pi"
