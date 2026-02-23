# NA111 Ethernet <->RS485 Link to nWRG Vacuum probes
drvAsynIPPortConfigure("LAN31", "192.168.0.31:8887", 0,0,0)
dbLoadRecords("db/nWRG.db", "P=Esther:,R=Vacuum:,PORT=LAN31,A=0")
