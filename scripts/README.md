# ESTHER Opertion Script

## How to Start Services 
1. Change to scripts folder

  ```
 $ cd .../esther-epics/scripts
  ```
2. Start EPICS Channel Archiver

  1. Start service:
```
$ ./launch-epics-archive.sh
```
  2. Check service is running with this [Link](http://localhost:4812/main) 

2. Start EPICS Channel Gateway to broadcast PV to other computers

  1. Start service:
```
$ ./launch-cagateway.sh
```
  2. Check service is running with CS-STudio App in client Computers

2. Start EPICS IOC Server for Kistler Pressure Gouge 

  1. Start service:
```bash
$ ./launch-kistler-ioc.sh
```
  2. Check IOC running in screen console `screen -r `. (Ctrl-A D to leave screen)

3. Start CS-Studio GUI Application 

  1. Start Application:
```
$ ./launch-cs-studio.sh
```


 
 

