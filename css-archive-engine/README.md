# Archive Engine 
## get latest at:  https://controlssoftware.sns.ornl.gov/css_phoebus/nightly
###  To replace engine:
```console
./archive-engine.sh -import ./xml/estherEngineConfigPulse.xml -replace_engine -engine estherPulse -settings esther.ini
```
### To run:
```console
sudo systemctl start epics-css-archive.service
```

