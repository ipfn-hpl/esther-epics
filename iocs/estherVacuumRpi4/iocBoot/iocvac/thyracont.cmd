# sudo dmesg| grep FTDI
# drvAsynSerialPortConfigure("RS232","/dev/ttyUSB1")
#drvAsynSerialPortConfigure("RS232","/dev/tty_thyracont")
#asynSetOption("RS232", 0, "baud", "9600")
#asynSetOption("RS232", 0, "bits", "8")
#asynSetOption("RS232", 0, "parity", "none")
#asynSetOption("RS232", 0, "stop", "1")
#asynSetOption("RS232", 0, "clocal", "Y")
#asynSetOption("RS232", 0, "crtscts", "N")
## Load record instances
#dbLoadRecords("db/thyracontV2.db", "P=Esther:,R=Vacuum:,PORT=RS232")
