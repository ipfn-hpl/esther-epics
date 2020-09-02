## ESTHER GAS SYSTEM Control

## Start System

1. Login to PC with esther account
2. Check if Gas Switchboard is powered
  * Wait 3 min and check if Rasperry Pi is running
```
ssh rpi-gas
```
3. Start CS-Studio:
```
/opt/epics/cs-studio/cs-studio&
```
  * Start with Default Workspace
  * Open OPI (e.g. Valve_Master.opi)
4. Start VirtualBox "Windows 7 Siemens" machine
  * On Windows Start "Tia Portal V13"
  * Open Last PLC project
