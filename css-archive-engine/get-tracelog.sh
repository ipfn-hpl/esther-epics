#!/bin/bash
# Scrip to get last messages from Esther Vacuum State machine
#mysql -u report -p"\$report" -D archive -e 'SELECT `smpl_time`, `severity_id`, `status_id`, `str_val` FROM `sample` WHERE `channel_id` = 12'
#mysql -u report -p"\$report" -D archive <<< 'show tables'
#mysql -u report -p"\$report" -D archive <<< "SELECT `smpl_time`, `severity_id`, `status_id`, `str_val` FROM `sample` WHERE `channel_id` = 13"
# Esther:Vacuum:TraceMessage channel_id = 71
# mysql -u report -p"\$report" -D archive <<< 'SELECT  `smpl_time`, `str_val` , `severity_id`, `status_id` FROM sample WHERE channel_id = 71 ORDER by `smpl_time` DESC LIMIT 20'
#psql -U postgres -d database_name -c "SELECT c_defaults  FROM user_info WHERE c_uid = 'testuser'"
#psql -U g04203_epicsarch -d g04203_epicsarch -h db.tecnico.ulisboa.pt -c "SELECT * FROM sample  WHERE channel_id=59 ORDER by smpl_time DESC LIMIT 10"
psql -U g04203_epicsarch -d g04203_epicsarch -h db.tecnico.ulisboa.pt -c "SELECT smpl_time, str_val, severity_id, status_id FROM sample  WHERE channel_id=59 ORDER by smpl_time DESC LIMIT 10"
