# ESTHER GAS SYSTEM Control (EPICS)

## Start Systems

1. Login to PC with esther account
2. Check if Gas Switchboard is powered
  * Wait 3 min and check if Rasperry Pi is running
```
ssh rpi-gas
>exit
```
3. Start CS-Studio, Channel Archive and other services:
[See scripts folder](/launch-scripts/)

4. If necessary Start VirtualBox "Windows 10" VM
  * On Windows Start "Tia Portal V17"
  * Open Last PLC project
5. Start phoebus
```
/opt/epics/phoebus.sh
```

## Web Displays
### Combustion Chamber Gas Injection System 
[Valve Display](http://10.10.136.128:8080/dbwr/view.jsp?display=https://raw.githubusercontent.com/ipfn-hpl/esther-epics/master/phoebus-display-builder/CSS/GasSystem/ValveDisplay.bob)

### Shock Tube Vacuum System 
[Vacuum System Main Display](http://10.10.136.128:8080/dbwr/view.jsp?display=https://raw.githubusercontent.com/ipfn-hpl/esther-epics/master/phoebus-display-builder/CSS/EstherVacuumMonitor.bob)   
[Vacuum Plots](http://10.10.136.128:8080/dbwr/view.jsp?display=https://raw.githubusercontent.com/ipfn-hpl/esther-epics/master/phoebus-display-builder/CSS/VacuumPlots.bob)

## GitHub repository
[Esther Epics](https://github.com/ipfn-hpl/esther-epics)

