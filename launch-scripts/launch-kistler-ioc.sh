#!/bin/bash
# Start screen Deamon
# retreive EPICS IOC console with screen -r
screen -dm bash -c "cd /home/esther/GIT_REPOS/esther-epics/iocs/serialKistler/iocBoot/iocKistler;  ../../bin/linux-x86_64/Kistler st.cmd"
