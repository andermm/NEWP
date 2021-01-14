#!/bin/bash

appsn=(bt.C.x sp.C.x is.C.x ft.C.x)

pkill -f "read.sh"

for (( i = 0; i < 4; i++ )); do
        apps=${appsn[i]}
        pkill -f "$apps"
done


nohup /home/lacp/NEWP/SH/read.sh > read.log
