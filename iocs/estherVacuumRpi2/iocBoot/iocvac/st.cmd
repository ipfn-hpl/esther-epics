#!../../bin/linux-arm/vac

#- You may have to change vac to something else
#- everywhere it appears in this file

< envPaths

#epicsEnvSet( "STREAM_PROTOCOL_PATH", "$(TOP)/db" )
#epicsEnvSet "P" "$(P=Esther)"

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/vac.dbd"
vac_registerRecordDeviceDriver pdbbase

## Load record instances
#dbLoadTemplate "db/user.substitutions"
dbLoadRecords "db/vacVersion.db", "user=pi"
#dbLoadRecords "db/dbSubExample.db", "user=pi"

drvAsynSerialPortConfigure("MDBUS", "/dev/tty_modbus", 0, 0, 0)
asynSetOption("MDBUS",0,"baud","19200")
asynSetOption("MDBUS",0,"parity","even")
asynSetOption("MDBUS",0,"bits","8")
asynSetOption("MDBUS",0,"stop","1")

# modbusInterposeConfig(portName,
#                      linkType,
#                      timeoutMsec,
#                      writeDelayMsec)
# Modbus link layer type:, 0 = TCP/IP, 1 = RTU, 2 = ASCII

modbusInterposeConfig("MDBUS",1,1000,5)
# drvModbusAsynConfigure(portName,
#                       tcpPortName,
#                       slaveAddress,
#                       modbusFunction,
#                       modbusStartAddress,
#                       modbusLength,
#                       dataType,
#                       pollMsec,
#                       plcType);
# Read  words (16 bits).  Function code=3 PDU address (start=0).
# USE PDU ADDRESSES. Prefix 0 is octal

## Load record instances
#drvModbusAsynConfigure("K1_Y0_Out_Word","MDBUS", 1, 6, 0, 1,    0,  100, "el-flow")
#dbLoadRecords("db/mb-lo.db","P=Esther:MFC1,R=Wink,PORT=K1_Y0_Out_Word,OFFSET=0")

#drvModbusAsynConfigure("K1_Y32_In_Word","MDBUS", 1, 3, 32, 1,    0,  100, "el-flow")
#dbLoadRecords("db/mb-li.db","P='Esther:MFC1',R=Measure,PORT=K1_Y32_In_Word,OFFSET=0,SCAN='I/O Intr'")

#drvModbusAsynConfigure("K1_Y33_Out_Word","MDBUS", 1, 6, 33, 1,    0,  100, "el-flow")
#dbLoadRecords("db/mb-lo.db","P=Esther:MFC1,R=Setpoint,PORT=K1_Y33_Out_Word,OFFSET=0")

#drvModbusAsynConfigure("K1_Y36_Out_Word","MDBUS", 1, 6, 36, 1,    0,  100, "el-flow")
#dbLoadRecords("db/mb-mbbo.db","P=Esther:MFC1,R=Control_Mode,PORT=K1_Y36_Out_Word,OFFSET=0")

#drvModbusAsynConfigure("K1_Y1063_In_Word","MDBUS", 1, 3, 1063, 1,    0,  100, "el-flow")
#dbLoadRecords("db/mb-li.db","P='Esther:MFC1',R=Temperature,PORT=K1_Y1063_In_Word,OFFSET=0,SCAN='I/O Intr'")

# Float Inputs BIGEndian
#ai
#drvModbusAsynConfigure("K1_V41216_In_Word",   "MDBUS",    1, 3,  41216,  2,    0,  100,    "el-flow")
#dbLoadRecords("db/mb-ai.db","P=Esther:MFC1,R=FMeasure,PORT=K1_V41216_In_Word,OFFSET=0,SCAN='I/O Intr'")

# ao
drvModbusAsynConfigure("K1_V41240_Out_Word",   "MDBUS",    1, 6,  41240,  2,    0,  100,    "el-flow")
dbLoadRecords("db/mb-ao.db","P=Esther:MFC1,R=FSetpoint,PORT=K1_V41240_Out_Word,OFFSET=0")
#ai
drvModbusAsynConfigure("K1_V41240_In_Word",   "MDBUS",    1, 3,  41240,  2,    0,  100,    "el-flow")
dbLoadRecords("db/mb-a1.db","P=Esther:MFC1,R=FSetpoint,PORT=K1_V41240_In_Word")

#drvModbusAsynConfigure("K1_V41272_In_Word",   "MDBUS",    1, 3,  41272,  2,    0,  100,    "el-flow")
#dbLoadRecords("db/mb-ai.db","P=Esther:MFC1,R=FTemperature,PORT=K1_V41272_In_Word,OFFSET=0,SCAN='I/O Intr'")

dbLoadRecords("db/vacVersion.db","P=Esther:MFC1")

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
#seq sncEstherVacuum, "user=pi,unit=Esther"
