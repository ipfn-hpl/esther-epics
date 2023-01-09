#!../../bin/linux-arm/vac

#- You may have to change vac to something else
#- everywhere it appears in this file

< envPaths

epicsEnvSet( "STREAM_PROTOCOL_PATH", "$(TOP)/db" )
#epicsEnvSet "P" "$(P=Esther)"

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/vac.dbd"
vac_registerRecordDeviceDriver pdbbase

## Load record instances
#dbLoadTemplate "db/user.substitutions"
#dbLoadRecords "db/vacVersion.db", "user=pi"
#dbLoadRecords "db/dbSubExample.db", "user=pi"

drvAsynSerialPortConfigure("MDBUS", "/dev/tty_modbus", 0, 0, 0)
asynSetOption("MDBUS",0,"baud","38400")
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
#dbLoadRecords("db/mb-lo.db","P=Esther:MFC-ST,R=Wink,PORT=K1_Y0_Out_Word,OFFSET=0")

drvModbusAsynConfigure("K1_R32_In_Word","MDBUS", 1, 3, 32, 1,    0,  100, "el-flow")
dbLoadRecords("db/mb-li.db","P='Esther:MFC-ST',R=Measure,PORT=K1_R32_In_Word,HOPR=41942")

#drvModbusAsynConfigure("K1_Y33_Out_Word","MDBUS", 1, 6, 33, 1,    0,  100, "el-flow")
#dbLoadRecords("db/mb-lo.db","P=Esther:MFC-ST,R=Setpoint,PORT=K1_Y33_Out_Word,OFFSET=0")

drvModbusAsynConfigure("K1_R36_In_Word", "MDBUS", 1, 3, 0x0024, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-cntrl-mode-mbbi.db","P=Esther:MFC-ST,R=Control-Mode,PORT=K1_R36_In_Word")
drvModbusAsynConfigure("K1_R36_Out_Word","MDBUS", 1, 6, 0x0024, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-cntrl-mode-mbbo.db","P=Esther:MFC-ST,R=Control-Mode,PORT=K1_R36_Out_Word")

#drvModbusAsynConfigure("K1_Y1063_In_Word","MDBUS", 1, 3, 1063, 1,    0,  100, "el-flow")
#dbLoadRecords("db/mb-li.db","P='Esther:MFC-ST',R=Temperature,PORT=K1_Y1063_In_Word,OFFSET=0,SCAN='I/O Intr'")

drvModbusAsynConfigure("K1_R3336_In_Word", "MDBUS", 1, 3, 0x0D08, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-count-mode-mbbi.db","P=Esther:MFC-ST,R=Counter-Mode,PORT=K1_R3336_In_Word")
drvModbusAsynConfigure("K1_R3336_Out_Word","MDBUS", 1, 6, 0x0D08, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-count-mode-mbbo.db","P=Esther:MFC-ST,R=Counter-Mode,PORT=K1_R3336_Out_Word")

# Float Inputs BIGEndian
#ai
drvModbusAsynConfigure("K1_R41216_In_Word",   "MDBUS",    1, 3,  41216,  2,    0,  500,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-ST,R=FMeasure,PORT=K1_R41216_In_Word")

# ao
drvModbusAsynConfigure("K1_R41240_Out_Word",   "MDBUS",   1, 16,  41240,  2,   0,  500,    "el-flow")
dbLoadRecords("db/mb-ao.db","P=Esther:MFC-ST,R=FSetpoint,PORT=K1_R41240_Out_Word")
drvModbusAsynConfigure("K1_R59416_Out_Word",   "MDBUS",   1, 16, 0xE818,  2,   0,  500,    "el-flow")
dbLoadRecords("db/mb-ao.db","P=Esther:MFC-ST,R=FCounter-Limit,HOPR=20.5,PORT=K1_R59416_Out_Word")
# ai
drvModbusAsynConfigure("K1_R41240_In_Word",   "MDBUS",    1, 3,   41240,  2,   0,  500,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-ST,R=FSetpoint,PORT=K1_R41240_In_Word")

drvModbusAsynConfigure("K1_R41272_In_Word",   "MDBUS",    1, 3,  41272,  2,    0,  500,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-ST,R=FTemperature,PORT=K1_R41272_In_Word")

drvModbusAsynConfigure("K1_R59400_In_Word",   "MDBUS",    1, 3,  0xE808,  2,    0,  500,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-ST,R=FCounter-Value,PORT=K1_R59400_In_Word")

drvModbusAsynConfigure("K1_R59416_In_Word",   "MDBUS",    1, 3,  0xE818,  2,    0,  500,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-ST,R=FCounter-Limit,PORT=K1_R59416_In_Word")

# MFC CT : 10 l /min high flow

drvModbusAsynConfigure("K2_R32_In_Word","MDBUS", 2, 3, 32, 1,    0,  100, "el-flow")
dbLoadRecords("db/mb-li.db","P='Esther:MFC-CT',R=Measure,PORT=K2_R32_In_Word,HOPR=41942")

drvModbusAsynConfigure("K2_R36_In_Word", "MDBUS", 2, 3, 0x0024, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-cntrl-mode-mbbi.db","P=Esther:MFC-CT,R=Control-Mode,PORT=K2_R36_In_Word")
drvModbusAsynConfigure("K2_R36_Out_Word","MDBUS", 2, 6, 0x0024, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-cntrl-mode-mbbo.db","P=Esther:MFC-CT,R=Control-Mode,PORT=K2_R36_Out_Word")

drvModbusAsynConfigure("K2_R3336_In_Word", "MDBUS", 2, 3, 0x0D08, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-count-mode-mbbi.db","P=Esther:MFC-CT,R=Counter-Mode,PORT=K2_R3336_In_Word")
drvModbusAsynConfigure("K2_R3336_Out_Word","MDBUS", 2, 6, 0x0D08, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-count-mode-mbbo.db","P=Esther:MFC-CT,R=Counter-Mode,PORT=K2_R3336_Out_Word")

# ai
drvModbusAsynConfigure("K2_R41216_In_Word",   "MDBUS",    2, 3,  41216,  2,    0,  500,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-CT,R=FMeasure,PORT=K2_R41216_In_Word")

drvModbusAsynConfigure("K2_R41240_In_Word",   "MDBUS",    2, 3,   41240,  2,   0,  500,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-CT,R=FSetpoint,PORT=K2_R41240_In_Word")

drvModbusAsynConfigure("K2_R41272_In_Word",   "MDBUS",    2, 3,  41272,  2,    0,  500,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-CT,R=FTemperature,PORT=K2_R41272_In_Word")

drvModbusAsynConfigure("K2_R59400_In_Word",   "MDBUS",    2, 3,  0xE808,  2,    0,  500,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-CT,R=FCounter-Value,PORT=K2_R59400_In_Word")

drvModbusAsynConfigure("K2_R59416_In_Word",   "MDBUS",    2, 3,  0xE818,  2,    0,  500,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-CT,R=FCounter-Limit,PORT=K2_R59416_In_Word")
# ao
drvModbusAsynConfigure("K2_R41240_Out_Word",   "MDBUS",   2, 16,  41240,  2,   0,  500,    "el-flow")
dbLoadRecords("db/mb-ao.db","P=Esther:MFC-CT,R=FSetpoint,PORT=K2_R41240_Out_Word")
drvModbusAsynConfigure("K2_R59416_Out_Word",   "MDBUS",   2, 16, 0xE818,  2,   0,  500,    "el-flow")
dbLoadRecords("db/mb-ao.db","P=Esther:MFC-CT,R=FCounter-Limit,HOPR=20.5,PORT=K2_R59416_Out_Word")

dbLoadRecords("db/vacVersion.db","P=Esther:MFC")

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
