# drvAsynSerialPortConfigure("MDBUS", "/dev/modbus", 0, 0, 0)
# asynSetOption("MDBUS",0,"baud","19200")
# asynSetOption("MDBUS",0,"parity","even")
# asynSetOption("MDBUS",0,"bits","8")
#asynSetOption("MDBUS",0,"stop","1")

# modbusInterposeConfig(portName,
#                      linkType,
#                      timeoutMsec,
#                      writeDelayMsec)
#- Modbus link layer type:, 0 = TCP/IP, 1 = RTU, 2 = ASCII

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
#- Read  words (16 bits).  Function code=3 PDU address (start=0).
# USE PDU ADDRESSES, prefix 0 is octal
# drvModbusAsynConfigure("K1_Y32_In_Word","MDBUS", 1, 3, 32, 1,    0,  100, "el-flow")
#- Load record instances
# dbLoadRecords("db/mb-li.db","P='Esther:MFC1',R=Measure,PORT=K1_Y32_In_Word,OFFSET=0,SCAN='I/O Intr'")

# drvModbusAsynConfigure("K1_Y1063_In_Word","MDBUS", 1, 3, 1063, 1,    0,  100, "el-flow")
# dbLoadRecords("db/mb-li.db","P='Esther:MFC1',R=Temperature,PORT=K1_Y1063_In_Word,OFFSET=0,SCAN='I/O Intr'")
