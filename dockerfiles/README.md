# Docker files for epics on Debian 11
## To run:
* Create Network
```
docker network create epicsNet
```
* Build Image
```
docker build  -t debian-epics .
```
* Run IOC
```
docker run --rm -it --network epicsNet --name ca-server debian-epics
root@xxxxxxxx:~/Projects# cd iocs/exampleIoc/iocBoot/iocexampleIoc
./st.cmd
dbl
```
* Run client
```
docker run --rm -it --network epicsNet --name ca-client debian-epics
root@yyyyyyy:~/Projects# caget user0:calc3
user0:calc3        0
```
