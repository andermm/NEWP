#!/bin/bash

PARTITION=(LACP20 LACP30 LACP40)

for (( i = 0; i < 3; i++ )); do
	ssh ${PARTITION[i]} 'nohup /home/lacp/NEWP/SH/kill.sh > kill.log' > /dev/null 2>&1 &
done