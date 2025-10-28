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
###
https://selfservice.dsi.tecnico.ulisboa.pt/group_db_admin.php?submit=Configurar&action=manage&groupname=estherPulse

```console
psql -U g04203_epicsarch  -h db.tecnico.ulisboa.pt
\c g04203_epicsarch
\dt
```
