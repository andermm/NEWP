#!/bin/bash

BASE=$HOME/NEWP
SCRIPTS=$BASE/SH
BENCHMARKS=$BASE/BENCHMARKS
LOGS=$BASE/LOGS
MACHINE_FILES=$BASE/MACHINE_FILES
LOGS_DOWNLOAD=$LOGS/LOGS_DOWNLOAD
LOGS_BACKUP_SRC_CODE=$LOGS/LOGS_BACKUP_SRC_CODE
DIR=$HOME/exp

#NPB Variables
NPBE=NPB3.4.1
APP_BIN_NPBE=$NPBE/NPB3.4-MPI/bin/
APP_CONFIG_NPBE=$NPBE/NPB3.4-MPI/config
APP_COMPILE_NPBE=$NPBE/NPB3.4-MPI

DIR=$HOME/exp
appsn=(bt sp is ft)
processesn=(16 64)
slaveok=slave1ok
MACHINEFILE16=$MACHINE_FILES/nodes16
MACHINEFILE64=$MACHINE_FILES/nodes64


#Kill processes
kill -15 -1


cd $DIR

for (( p = 0; p < 2; p++ )); do
	processes=${processesn[p]}
	for (( n = 0; n < 4; n++ )); do
		app=${appsn[n]}
			for i in {1..331..30}; do 
				FILE_[$i]="$app"_"$i"
				if [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[2]}_1_16 ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE16 \
							"$BENCHMARKS/$APP_BIN_NPBE"is.C.x
					done

			
				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[3]}_31_16  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE16 \
							"$BENCHMARKS/$APP_BIN_NPBE"ft.C.x
					done


				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[2]}_61_16  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE16 \
							"$BENCHMARKS/$APP_BIN_NPBE"ft.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[3]}_91_16  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE16 \
							"$BENCHMARKS/$APP_BIN_NPBE"is.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[0]}_121_16  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE16 \
							"$BENCHMARKS/$APP_BIN_NPBE"is.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[1]}_151_16  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE16 \
							"$BENCHMARKS/$APP_BIN_NPBE"is.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[0]}_181_16  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE16 \
							"$BENCHMARKS/$APP_BIN_NPBE"ft.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[1]}_211_16  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE16 \
							"$BENCHMARKS/$APP_BIN_NPBE"ft.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[0]}_241_16  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE16 \
							"$BENCHMARKS/$APP_BIN_NPBE"bt.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[1]}_271_16  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE16 \
							"$BENCHMARKS/$APP_BIN_NPBE"sp.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[0]}_301_16  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE16 \
							"$BENCHMARKS/$APP_BIN_NPBE"sp.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[1]}_331_16  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE16 \
							"$BENCHMARKS/$APP_BIN_NPBE"bt.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[2]}_1_64 ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE64 \
							"$BENCHMARKS/$APP_BIN_NPBE"is.C.x
					done

			
				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[3]}_31_64  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE64 \
							"$BENCHMARKS/$APP_BIN_NPBE"ft.C.x
					done


				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[2]}_61_64  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE64 \
							"$BENCHMARKS/$APP_BIN_NPBE"ft.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[3]}_91_64  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE64 \
							"$BENCHMARKS/$APP_BIN_NPBE"is.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[0]}_121_64  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE64 \
							"$BENCHMARKS/$APP_BIN_NPBE"is.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[1]}_151_64  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE64 \
							"$BENCHMARKS/$APP_BIN_NPBE"is.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[0]}_181_64  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE64 \
							"$BENCHMARKS/$APP_BIN_NPBE"ft.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[1]}_211_64  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE64 \
							"$BENCHMARKS/$APP_BIN_NPBE"ft.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[0]}_241_64  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE64 \
							"$BENCHMARKS/$APP_BIN_NPBE"bt.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[1]}_271_64  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE64 \
							"$BENCHMARKS/$APP_BIN_NPBE"sp.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[0]}_301_64  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE64 \
							"$BENCHMARKS/$APP_BIN_NPBE"sp.C.x
					done

				elif [[ -e "${FILE_[i]}"_$processes && "${FILE_[i]}"_$processes == ${appsn[1]}_331_64  ]]; then
					touch $slaveok
					while [[ true ]]; do	
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np processesn \
							-machinefile $MACHINEFILE64 \
							"$BENCHMARKS/$APP_BIN_NPBE"bt.C.x
					done
			fi
		done
	done
done
