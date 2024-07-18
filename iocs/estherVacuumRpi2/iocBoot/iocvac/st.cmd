#!../../bin/linux-aarch64/vac

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

drvAsynSerialPortConfigure("MDBUS", "/dev/ttyModbus", 0, 0, 0)
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
# Polling delay time in msec for the polling thread for read functions. 
# For write functions, a non-zero value means that the Modbus data should, 
# be read once when the port driver is first created.
# Read  words (16 bits).  Function code=3 PDU address (start=0).
# USE PDU ADDRESSES. Prefix 0 is octal

## Load record instances
dbLoadRecords("db/mfc-control.db", "P=Esther:,R=MFC-CT:")

#drvModbusAsynConfigure("K1_Y0_Out_Word","MDBUS", 1, 6, 0, 1,    0,  100, "el-flow")
#dbLoadRecords("db/mb-lo.db","P=Esther:MFC-ST,R=Wink,PORT=K1_Y0_Out_Word,OFFSET=0")

drvModbusAsynConfigure("K1_R33_In_Word","MDBUS", 1, 3, 0x0020, 1,    0,  100, "el-flow")
dbLoadRecords("db/mb-li.db","P='Esther:MFC-ST',R=Measure,PORT=K1_R33_In_Word,HOPR=41942")

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

drvModbusAsynConfigure("K1_Y3334_Out_Word","MDBUS", 1, 6, 0x0D05, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-lo.db","P=Esther:MFC-ST,R=Counter-Setpoint-Mode,PORT=K1_Y3334_Out_Word,OFFSET=0,HOPR=1")

drvModbusAsynConfigure("K1_Y3110_Out_Word","MDBUS", 1, 6, 0x0C25, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-lo.db","P=Esther:MFC-ST,R=Alarm-Setpoint-Mode,PORT=K1_Y3110_Out_Word,OFFSET=0,HOPR=1")

drvModbusAsynConfigure("K1_Y0053_In_Word","MDBUS",  1, 3, 0x0034, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-li.db","P=Esther:MFC-ST,R=Alarm-Info,PORT=K1_Y0053_In_Word,HOPR=255")

drvModbusAsynConfigure("K1_Y3108_Out_Word","MDBUS", 1, 6, 0x0C23, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-lo.db","P=Esther:MFC-ST,R=Alarm-Mode,PORT=K1_Y3108_Out_Word,OFFSET=0,HOPR=3")

# Float Inputs BIGEndian
#ai
drvModbusAsynConfigure("K1_R41217_In_Word",   "MDBUS",    1, 3, 0xA100,  2,    0,  500,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-ST,R=FMeasure,PORT=K1_R41217_In_Word,PREC=2,EGU=mln/min")

# ao
drvModbusAsynConfigure("K1_R41240_Out_Word",   "MDBUS",   1, 16,  41240,  2,   0,  500,    "el-flow")
dbLoadRecords("db/mb-ao.db","P=Esther:MFC-ST,R=FSetpoint,PORT=K1_R41240_Out_Word,HOPR=9.0,PREC=2,EGU=mln/min")
drvModbusAsynConfigure("K1_R59416_Out_Word",   "MDBUS",   1, 16, 0xE818,  2,   0,  500,    "el-flow")
dbLoadRecords("db/mb-ao.db","P=Esther:MFC-ST,R=FCounter-Limit,PORT=K1_R59416_Out_Word,HOPR=1.0,PREC=2,EGU=ln")
# ai
drvModbusAsynConfigure("K1_R41240_In_Word",   "MDBUS",    1, 3,   41240,  2,   0,  500,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-ST,R=FSetpoint,PORT=K1_R41240_In_Word,PREC=2,EGU=mln/min")

drvModbusAsynConfigure("K1_R41273_In_Word",   "MDBUS",    1, 3,  0xA138,  2,    0,  500,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-ST,R=FTemperature,PORT=K1_R41273_In_Word,PREC=2,EGU=C")

drvModbusAsynConfigure("K1_R59401_In_Word",   "MDBUS",    1, 3,  0xE808,  2,    0,  500,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-ST,R=FCounter-Value,PORT=K1_R59401_In_Word,PREC=2,EGU=ln")

drvModbusAsynConfigure("K1_R59416_In_Word",   "MDBUS",    1, 3,  0xE818,  2,    0,  500,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-ST,R=FCounter-Limit,PORT=K1_R59416_In_Word,PREC=2,EGU=ln")

# MFC CT : 10 l/min high flow Modbux address: 2
# MFC ST : 9 ml/min high flow Modbux address: 1

drvModbusAsynConfigure("K2_Y0053_In_Word","MDBUS",  2, 3, 0x0034, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-li.db","P=Esther:MFC-CT,R=Alarm-Info,PORT=K2_Y0053_In_Word,HOPR=255")

drvModbusAsynConfigure("K2_Y3108_Out_Word","MDBUS", 2, 6, 0x0C23, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-lo.db","P=Esther:MFC-CT,R=Alarm-Mode,PORT=K2_Y3108_Out_Word,OFFSET=0,HOPR=3")

drvModbusAsynConfigure("K2_Y3110_Out_Word","MDBUS", 2, 6, 0x0C25, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-lo.db","P=Esther:MFC-CT,R=Alarm-Setpoint-Mode,PORT=K2_Y3110_Out_Word,OFFSET=0,HOPR=1")

drvModbusAsynConfigure("K2_Y3334_Out_Word","MDBUS", 2, 6, 0x0D05, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-lo.db","P=Esther:MFC-CT,R=Counter-Setpoint-Mode,PORT=K2_Y3334_Out_Word,OFFSET=0,HOPR=1")

#drvModbusAsynConfigure("K2_Y3334_Outb_Word","MDBUS", 2, 6, 0x0D05, 1,    0,  500, "el-flow")
#dbLoadRecords("db/mb-bo.db","P=Esther:MFC-CT,R=Counter-Setpoint-Mode,PORT=K2_Y3334_Outb_Word,OFFSET=0")

drvModbusAsynConfigure("K2_Y3335_In_Word","MDBUS",  2, 3, 0x0D06, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-li.db","P=Esther:MFC-CT,R=Counter-New-Setpoint,PORT=K2_Y3335_In_Word,HOPR=32000")

drvModbusAsynConfigure("K2_Y3335_Out_Word","MDBUS", 2, 6, 0x0D06, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-lo.db","P=Esther:MFC-CT,R=Counter-New-Setpoint,PORT=K2_Y3335_Out_Word,OFFSET=0")

drvModbusAsynConfigure("K1_Y3335_Out_Word","MDBUS", 1, 6, 0x0D06, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-lo.db","P=Esther:MFC-ST,R=Counter-New-Setpoint,PORT=K1_Y3335_Out_Word,OFFSET=0")

drvModbusAsynConfigure("K1_Y3689_In_Word","MDBUS",  1, 3, 0x0E68, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-reset-mbbi.db","P=Esther:MFC-ST,R=Reset,PORT=K1_Y3689_In_Word")
drvModbusAsynConfigure("K1_Y3689_Out_Word","MDBUS",  1, 6, 0x0E68, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-reset-mbbo.db","P=Esther:MFC-ST,R=Reset,PORT=K1_Y3689_Out_Word")

drvModbusAsynConfigure("K2_Y3689_In_Word","MDBUS",  2, 3, 0x0E68, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-reset-mbbi.db","P=Esther:MFC-CT,R=Reset,PORT=K2_Y3689_In_Word")
drvModbusAsynConfigure("K2_Y3689_Out_Word","MDBUS",  2, 6, 0x0E68, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-reset-mbbo.db","P=Esther:MFC-CT,R=Reset,PORT=K2_Y3689_Out_Word")

drvModbusAsynConfigure("K1_Y3338_Out_Word","MDBUS", 1, 6, 0x0D09, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-lo.db","P=Esther:MFC-ST,R=Reset-Counter-Enable,PORT=K1_Y3338_Out_Word,OFFSET=0")
drvModbusAsynConfigure("K1_Y3338_In_Word","MDBUS",  1, 3, 0x0D09, 1,    0,  2000, "el-flow")
dbLoadRecords("db/mb-reset-counter-mbbi.db","P=Esther:MFC-ST,R=Reset-Counter-Enable,PORT=K1_Y3338_In_Word")

drvModbusAsynConfigure("K2_Y3114_Out_Word","MDBUS", 2, 6, 0x0C29, 1,    0,  2000, "el-flow")
dbLoadRecords("db/mb-lo.db","P=Esther:MFC-CT,R=Reset-Alarm-Enable,PORT=K2_Y3114_Out_Word,OFFSET=0")
drvModbusAsynConfigure("K2_Y3114_In_Word","MDBUS",  2, 3, 0x0C29, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-reset-counter-mbbi.db","P=Esther:MFC-CT,R=Reset-Alarm-Enable,PORT=K2_Y3114_In_Word")

drvModbusAsynConfigure("K2_Y3338_Out_Word","MDBUS", 2, 6, 0x0D09, 1,    0,  2000, "el-flow")
dbLoadRecords("db/mb-lo.db","P=Esther:MFC-CT,R=Reset-Counter-Enable,PORT=K2_Y3338_Out_Word,OFFSET=0")
drvModbusAsynConfigure("K2_Y3338_In_Word","MDBUS",  2, 3, 0x0D09, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-reset-counter-mbbi.db","P=Esther:MFC-CT,R=Reset-Counter-Enable,PORT=K2_Y3338_In_Word")

drvModbusAsynConfigure("K2_R33_In_Word","MDBUS", 2, 3, 0x0020, 1,    0,  100, "el-flow")
dbLoadRecords("db/mb-li.db","P='Esther:MFC-CT',R=Measure,PORT=K2_R33_In_Word,HOPR=41942")

drvModbusAsynConfigure("K2_R36_In_Word", "MDBUS", 2, 3, 0x0024, 1,    0,  2000, "el-flow")
dbLoadRecords("db/mb-cntrl-mode-mbbi.db","P=Esther:MFC-CT,R=Control-Mode,PORT=K2_R36_In_Word")
drvModbusAsynConfigure("K2_R36_Out_Word","MDBUS", 2, 6, 0x0024, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-cntrl-mode-mbbo.db","P=Esther:MFC-CT,R=Control-Mode,PORT=K2_R36_Out_Word")

drvModbusAsynConfigure("K2_R3336_In_Word", "MDBUS", 2, 3, 0x0D08, 1,    0,  5000, "el-flow")
dbLoadRecords("db/mb-count-mode-mbbi.db","P=Esther:MFC-CT,R=Counter-Mode,PORT=K2_R3336_In_Word")
drvModbusAsynConfigure("K2_R3336_Out_Word","MDBUS", 2, 6, 0x0D08, 1,    0,  500, "el-flow")
dbLoadRecords("db/mb-count-mode-mbbo.db","P=Esther:MFC-CT,R=Counter-Mode,PORT=K2_R3336_Out_Word")

# ai
drvModbusAsynConfigure("K2_R41217_In_Word",   "MDBUS",    2, 3,  0xA100,  2,    0,  100,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-CT,R=FMeasure,PORT=K2_R41217_In_Word,EGU=ln/min")

drvModbusAsynConfigure("K2_R41240_In_Word",   "MDBUS",    2, 3,   41240,  2,   0,  100,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-CT,R=FSetpoint,PORT=K2_R41240_In_Word,HOPR=10.0,PREC=2,EGU=ln/min")
drvModbusAsynConfigure("K2_R41240_Out_Word",   "MDBUS",   2, 16,  41240,  2,   0,  500,    "el-flow")
dbLoadRecords("db/mb-ao.db","P=Esther:MFC-CT,R=FSetpoint,PORT=K2_R41240_Out_Word,HOPR=10.0,PREC=2,EGU=ln/min")

drvModbusAsynConfigure("K2_R41273_In_Word",   "MDBUS",    2, 3,  0xA138,  2,    0,  200,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-CT,R=FTemperature,PORT=K2_R41273_In_Word,EGU=C")

drvModbusAsynConfigure("K2_R59401_Out_Word",   "MDBUS",    2, 16,  0xE808,  2,    0,  500,    "el-flow")
dbLoadRecords("db/mb-ao.db","P=Esther:MFC-CT,R=FCounter-Value,PORT=K2_R59401_Out_Word,EGU=ln")
drvModbusAsynConfigure("K2_R59401_In_Word",   "MDBUS",    2, 3,  0xE808,  2,    0,  100,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-CT,R=FCounter-Value,PORT=K2_R59401_In_Word,EGU=ln")

drvModbusAsynConfigure("K2_R59416_In_Word",   "MDBUS",    2, 3,  0xE818,  2,    0,  5000,    "el-flow")
dbLoadRecords("db/mb-ai.db","P=Esther:MFC-CT,R=FCounter-Limit,PORT=K2_R59416_In_Word,EGU=ln")
# ao
drvModbusAsynConfigure("K2_R59416_Out_Word",   "MDBUS",   2, 16, 0xE818,  2,   0,  5000,    "el-flow")
dbLoadRecords("db/mb-ao.db","P=Esther:MFC-CT,R=FCounter-Limit,HOPR=100.0,PORT=K2_R59416_Out_Word")


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
