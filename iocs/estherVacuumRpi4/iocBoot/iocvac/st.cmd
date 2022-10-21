#!../../bin/linux-aarch64/vac

#- You may have to change vac to something else
#- everywhere it appears in this file

< envPaths

epicsEnvSet("STREAM_PROTOCOL_PATH", "$(TOP)/db")
epicsEnvSet("SAVE_DIR", "$(TOP)/iocBoot/$(IOC)/save")
epicsEnvSet("EPICS_CA_ADDR_LIST", "192.168.0.21 192.168.0.60 192.168.0.99 192.168.1.98")
epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")

epicsEnvSet "P" "$(P=Esther)"

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/vac.dbd"
vac_registerRecordDeviceDriver pdbbase

#Configure PLC Connection
s7nodaveConfigureIsoTcpPort("vacPLC", "192.168.0.1", 0)
dbLoadRecords("db/S7-eda-valve.db", "P=Esther:,R=EDA")
dbLoadRecords("db/S7-hva-valve.db", "P=Esther:,R=HVA")

# Configure Poll Group
s7nodaveConfigurePollGroup("vacPLC", "default", 1.0, 0)
s7nodaveConfigurePollGroup("vacPLC", "fast", 0.1, 0)

## Load record instances
# dbLoadRecords "db/vacVersion.db", "user=pi"

# Arduino MST12 ARM control CTST
# /dev/ttyACM0
#drvAsynSerialPortConfigure("RS232A1","/dev/armCTST")
#asynSetOption("RS232A1", 0, "baud", "115200")
#asynSetOption("RS232A1", 0, "bits", "8")
#asynSetOption("RS232A1", 0, "parity", "none")
#asynSetOption("RS232A1", 0, "stop", "1")
#dbLoadRecords("db/armcontrol.db", "P=Esther:,R=ARM:,A=1")

# Arduino MST12 ARM control
#drvAsynSerialPortConfigure("RS232A2","/dev/armSTDT")
#asynSetOption("RS232A2", 0, "baud", "115200")
#asynSetOption("RS232A2", 0, "bits", "8")
#asynSetOption("RS232A2", 0, "parity", "none")
#asynSetOption("RS232A2", 0, "stop", "1")
#dbLoadRecords("db/armcontrol.db", "P=Esther:,R=ARM:,A=2")

epicsEnvSet "A" "$(A=3)"
epicsEnvSet "BRS" "$(BRS=RS232A$(A))"
## Arduino HVA Gate Valve control
drvAsynSerialPortConfigure("$(BRS)","/dev/gatevalveCTST",0,0,0)
asynSetOption("$(BRS)", 0, "baud", "115200")
asynSetOption("$(BRS)", 0, "bits", "8")
asynSetOption("$(BRS)", 0, "parity", "none")
asynSetOption("$(BRS)", 0, "stop", "1")
dbLoadRecords("db/gate-valve.db", "P=$(P):,R=HVA:,A=3")

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
dbLoadRecords("db/edwards-scu800.db", "P=Esther:,R=EDW:,BUS=RS485")

## EDWARDS ADC Vacuum Monitor
drvAsynSerialPortConfigure("RS232E1","/dev/edwardsADC")
asynSetOption("RS232E1", 0, "baud", "9600")
asynSetOption("RS232E1", 0, "bits", "8")
asynSetOption("RS232E1", 0, "parity", "none")
asynSetOption("RS232E1", 0, "stop", "1")
#asynSetOption("RS232E1", 0, "clocal", "Y")
##asynSetOption("RS232E1", 0, "crtscts", "N")
dbLoadRecords("db/edwards-adc.db", "P=Esther:,R=Vacuum:,A=1,BUS=RS232E1")

dbLoadRecords("db/esther-states.db", "P=Esther:,R=Vacuum:")

# drvAsynSerialPortConfigure("MDBUS", "/dev/modbus", 0, 0, 0)
# asynSetOption("MDBUS",0,"baud","19200")
# asynSetOption("MDBUS",0,"parity","even")
# asynSetOption("MDBUS",0,"bits","8")
#asynSetOption("MDBUS",0,"stop","1")

# modbusInterposeConfig(portName,
#                      linkType,
#                      timeoutMsec,
#                      writeDelayMsec)
# Modbus link layer type:, 0 = TCP/IP, 1 = RTU, 2 = ASCII

# modbusInterposeConfig("MDBUS",1,1000,0)
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
# USE PDU ADDRESSES, prefix 0 is octal
# drvModbusAsynConfigure("K1_Y32_In_Word","MDBUS", 1, 3, 32, 1,    0,  100, "el-flow")
## Load record instances
# dbLoadRecords("db/mb-li.db","P='Esther:MFC1',R=Measure,PORT=K1_Y32_In_Word,OFFSET=0,SCAN='I/O Intr'")

# drvModbusAsynConfigure("K1_Y1063_In_Word","MDBUS", 1, 3, 1063, 1,    0,  100, "el-flow")
# dbLoadRecords("db/mb-li.db","P='Esther:MFC1',R=Temperature,PORT=K1_Y1063_In_Word,OFFSET=0,SCAN='I/O Intr'")


#- Set this to see messages from mySub
#var mySubDebug 1

#- Run this to trace the stages of iocInit
#traceIocInit

cd "${TOP}/iocBoot/${IOC}"

save_restoreSet_status_prefix("Esther:")
set_requestfile_path("$(SAVE_DIR)")
set_savefile_path("$(SAVE_DIR)")
set_pass0_restoreFile("$(IOC).sav")
set_pass1_restoreFile("$(IOC).sav")
dbLoadRecords("$(AUTOSAVE)/asApp/Db/save_restoreStatus.db", "P=Esther:Vacuum")

# Number of sequenced backup files (e.g., 'auto_settings.sav0') to write
save_restoreSet_NumSeqFiles(3)

# Time interval between sequenced backups
save_restoreSet_SeqPeriodInSeconds(600)

iocInit

# Handle autosave 'commands' contained in loaded databases.
makeAutosaveFiles()
# Do after 'cp info_settings.req save/iocvac.req'


# Start periodic 'save’
# create_monitor_set("auto_settings.req", 30, "P=Esther:vacuum")
# makeAutosaveFileFromDbInfo("$(SAVE_DIR)/$(IOC).req", "autosaveFields")
create_monitor_set("$(IOC).req", 30, "P=Esther:vacuum")

## Start any sequence programs
seq sncEstherVacuum, "unit=Esther"

