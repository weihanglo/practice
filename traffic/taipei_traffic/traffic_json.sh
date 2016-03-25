#! /bin/bash
while true
do Rscript traffic_json.R %> traffic_json.Rout

sleep 900

done
