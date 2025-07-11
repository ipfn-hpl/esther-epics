#!../../bin/linux-x86_64/vrs53
#/etc/udev/rules.d/40-usb.rules               
#Bus 001 Device 021: ID 0403:6015 Future Technology Devices International, Ltd Bridge(I2C/SPI/UART/FIFO)
# ACTION=="add", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", SYMLINK+="tty_thyracont"

#- SPDX-FileCopyrightText: 2003 Argonne National Laboratory
#-
#- SPDX-License-Identifier: EPICS

#- You may have to change vrs53 to something else
#- everywhere it appears in this file

< envPaths

epicsEnvSet("STREAM_PROTOCOL_PATH", "$(TOP)/db")

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/vrs53.dbd"
vrs53_registerRecordDeviceDriver pdbbase

#drvAsynSerialPortConfigure("RS232","/dev/ttyUSB1")
drvAsynSerialPortConfigure("RS232","/dev/tty_thyracont")
asynSetOption("RS232", 0, "baud", "9600")
asynSetOption("RS232", 0, "bits", "8")
asynSetOption("RS232", 0, "parity", "none")
asynSetOption("RS232", 0, "stop", "1")
#asynSetOption("RS232", 0, "clocal", "Y")
#asynSetOption("RS232", 0, "crtscts", "N")
## Load record instances
dbLoadRecords("db/thyracontv2.db", "P=THY:,R=Test:,PORT=RS232")

cd "${TOP}/iocBoot/${IOC}"
iocInit

# List PVs
pval
