#!/bin/bash

appsn=(bt.C.x sp.C.x is.C.x ft.C.x)

for (( i = 0; i < 4; i++ )); do
        apps=${appsn[i]}
        pkill -f "$apps"
        pkill -f "read.sh"
done

nohup /home/lacp/NEWP/SH/read.sh > read.log
