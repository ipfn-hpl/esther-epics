# ESTHER EPICS Start Scripts

## How to Start Services 
1. Change to scripts folder
   ```
   $ cd  ~/GIT_REPOS/esther-epics/launch-scripts
   ```

1. Start EPICS Channel Archiver
   * Start service:
   ```
   $ ./launch-epics-archive.sh
   ```
   * Check service is running with this Link: [/localhost:4812/main](http://localhost:4812/main)
   * (To stop service use: [localhost:4812/stop](http://localhost:4812/stop))

1. Start EPICS Channel Gateway to broadcast PVs to other computers
   1. Start service:
   ```
   $ ./launch-cagateway.sh
   ```
   2. Check service is running with CS-Studio App in client Computers

1. Start EPICS IOC Server for Kistler Pressure Gauges 

   1. Start service:
   ```bash
   $ ./launch-kistler-ioc.sh
   ```
   2. Check IOC is running in screen console: `screen -r `. (Ctrl-A, D to leave screen)

3. Start CS-Studio GUI Application 

   1. Start Application:
   ```
   $ ./launch-cs-studio.sh
   ```
   2. Start with Default Workspace
   3.  Open OPI (e.g. MainDisplay.opi)



 
 

