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

1. This shows you the size of all tables in the schema public:
```console
pg_dump -U g04203_epicsarch -h db.tecnico.ulisboa.pt g04203_epicsarch > esther_pg_dump.sql

select
  table_name,
  pg_size_pretty(pg_total_relation_size(quote_ident(table_name))),
  pg_total_relation_size(quote_ident(table_name))
from information_schema.tables
where table_schema = 'public'
order by 3 desc;

```

