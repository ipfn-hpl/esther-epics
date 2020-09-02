#!../../bin/linux-x86_64/Kistler

## You may have to change Kistler to something else
## everywhere it appears in this file

#< envPaths

## Register all support components
dbLoadDatabase("../../dbd/Kistler.dbd",0,0)
Kistler_registerRecordDeviceDriver(pdbbase) 

epicsEnvSet ("STREAM_PROTOCOL_PATH", ".:../protocols")                                                                                               

#
#drvAsynSerialPortConfigure("KST1","/dev/ttyUSB1")
#http://hintshop.ludvig.co.nz/show/persistent-names-usb-serial-devices/
#http://hintshop.ludvig.co.nz/show/persistent-names-usb-serial-devices/

#drvAsynSerialPortConfigure("KST1","/dev/kistler")
drvAsynSerialPortConfigure("KST1","/dev/ttyUSB0")
#
asynSetOption("KST1", 0, "baud", "115200")
asynSetOption("KST1", 0, "bits", "8")
asynSetOption("KST1", 0, "parity", "none")
asynSetOption("KST1", 0, "stop", "1")
asynSetOption("KST1", 0, "clocal", "Y")
asynSetOption("KST1", 0, "crtscts", "N")

drvAsynSerialPortConfigure("QNT1","/dev/ttyUSB1")

asynSetOption("QNT1", 0, "baud", "9600")
asynSetOption("QNT1", 0, "bits", "8")
asynSetOption("QNT1", 0, "parity", "none")
asynSetOption("QNT1", 0, "stop", "1")
asynSetOption("QNT1", 0, "clocal", "Y")
asynSetOption("QNT1", 0, "crtscts", "N")

## Load record instances
dbLoadRecords("../../db/quantel.db","user=Esther:Quantel,bus=QNT1")
dbLoadRecords("../../db/kist.db","user=Esther:Bombe")

iocInit()

## Start any sequence programs
#seq sncKistler,"user=bernardo"
