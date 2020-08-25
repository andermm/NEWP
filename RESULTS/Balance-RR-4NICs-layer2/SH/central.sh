#!/bin/bash
BASE=$HOME/NEWP
cd $BASE; nohup ./SH/experiments_exec.sh > $BASE/apps_std_out.log 2>&1 &
