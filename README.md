# ESTHER GAS SYSTEM Control (EPICS)

## Start Systems

1. Login to PC with esther account
2. Check if Gas Switchboard is powered
  * Wait 3 min and check if all Epics IOCs are running
```bash
ssh rpi2-gas
>sudo systemctl status esther-gas-ioc.service
>exit

ssh rpi4-gas
>sudo systemctl status esther-mfc-ioc.service
>exit

ssh galatea
>sudo systemctl status esther-vacuum-ioc.service
>sudo systemctl status epics-python-caput.service
>exit

ssh rpi4-vacuum
>sudo systemctl status esther-vacuum-ioc.service
>exit
```

3. Check/Start Channel Archive:
```bash
sudo systemctl status epics-css-archive.service
```

4. Check/Start CS-Studio and other services:
[See other scripts in folder](/launch-scripts/)

5. If necessary Start VirtualBox "Windows 10" VM
  * On Windows Start "Tia Portal V17"
  * Open Last PLC project
6. Start CS Phoebus GUI panels
```bash
/opt/epics/phoebus.sh
```

## Web EPICS Displays (Only on CTN Network)
### Combustion Chamber Gas Injection System
(You main need to change IP number, to point to Golem PC)
* [Valve Display](http://golem.local:8080/dbwr/view.jsp?display=https://raw.githubusercontent.com/ipfn-hpl/esther-epics/master/phoebus-display-builder/CSS/GasSystem/ValveDisplay.bob)

### Shock Tube Vacuum System 
* [Vacuum System Main Display](http://golem.local:8080/dbwr/view.jsp?display=https://raw.githubusercontent.com/ipfn-hpl/esther-epics/master/phoebus-display-builder/CSS/EstherVacuumMonitor.bob)   
* [Vacuum States](http://golem.local:8080/dbwr/view.jsp?display=https://raw.githubusercontent.com/ipfn-hpl/esther-epics/master/phoebus-display-builder/CSS/VacuumStates.bob)
* [Vacuum Plots](http://golem.local:8080/dbwr/view.jsp?display=https://raw.githubusercontent.com/ipfn-hpl/esther-epics/master/phoebus-display-builder/CSS/VacuumPlots.bob)

## Dry Pumps Displays - Only on Esther HPL Internal Network
1. Check Temperatures in Vacuum Dry Pumps GX600L
 * [CTST](http://192.168.0.41/sev_gauges.html)
 * [STDT](http://192.168.0.42/sev_gauges.html)

## GitHub repository
[Esther Epics](https://github.com/ipfn-hpl/esther-epics)

