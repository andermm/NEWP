#!/bin/bash

BASE=$HOME/NEWP
SCRIPTS=$BASE/SH
BENCHMARKS=$BASE/BENCHMARKS
LOGS=$BASE/LOGS
MACHINE_FILES=$BASE/MACHINE_FILES
LOGS_DOWNLOAD=$LOGS/LOGS_DOWNLOAD
LOGS_BACKUP_SRC_CODE=$LOGS/LOGS_BACKUP_SRC_CODE
DIR=$HOME/exp
appsn=(bt sp is ft)
processesn=(16 64)
slaveok=slave$(echo ${HOSTNAME:4:1})ok
MACHINEFILE16=$MACHINE_FILES/nodes16_${HOSTNAME}
MACHINEFILE64=$MACHINE_FILES/nodes64_${HOSTNAME}
NPBE=NPB3.4.1
APP_BIN_NPBE=$NPBE/NPB3.4-MPI/bin/

cd $DIR

	for (( n = 0; n < 4; n++ )); do
		app=${appsn[n]}
		for i in {1..231..10}; do 
				FILE_[$i]="$app"_"$i"
				if [[ -e "${FILE_[i]}"\_16 ]]; then
					touch $slaveok
					MACHINEFILE=$MACHINEFILE16

					while [[ true ]]; do
					if [[ "${FILE_[i]}"_16 == ${appsn[2]}_1_16 ]]; then
						KERNEL=is.C.x
					elif [[ "${FILE_[i]}"_16 == ${appsn[3]}_11_16 ]]; then
						KERNEL=ft.C.x
					elif [[ "${FILE_[i]}"_16 == ${appsn[2]}_21_16 ]]; then
						KERNEL=ft.C.x
					elif [[ "${FILE_[i]}"_16 == ${appsn[3]}_31_16 ]]; then
						KERNEL=is.C.x
					elif [[ "${FILE_[i]}"_16 == ${appsn[0]}_41_16 ]]; then
						KERNEL=is.C.x
					elif [[ "${FILE_[i]}"_16 == ${appsn[1]}_51_16 ]]; then
						KERNEL=is.C.x
					elif [[ "${FILE_[i]}"_16 == ${appsn[0]}_61_16 ]]; then
						KERNEL=ft.C.x
					elif [[ "${FILE_[i]}"_16 == ${appsn[1]}_71_16 ]]; then
						KERNEL=ft.C.x
					elif [[ "${FILE_[i]}"_16 == ${appsn[0]}_81_16 ]]; then
						KERNEL=bt.C.x
					elif [[ "${FILE_[i]}"_16 == ${appsn[1]}_91_16  ]]; then
						KERNEL=sp.C.x
					elif [[ "${FILE_[i]}"_16 == ${appsn[0]}_101_16  ]]; then
						KERNEL=sp.C.x
					elif [[ "${FILE_[i]}"_16 == ${appsn[1]}_111_16  ]]; then
						KERNEL=bt.C.x
					fi

					date
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np 16 \
							-machinefile $MACHINEFILE \
							"$BENCHMARKS/$APP_BIN_NPBE"$KERNEL
					done

				elif [[ -e "${FILE_[i]}"\_64 ]]; then
					touch $slaveok
					MACHINEFILE=$MACHINEFILE64
					while [[ true ]]; do
									
					if [[ "${FILE_[i]}"_64 == ${appsn[2]}_121_64 ]]; then
						KERNEL=is.C.x
					elif [[ "${FILE_[i]}"_64 == ${appsn[3]}_131_64 ]]; then
						KERNEL=ft.C.x
					elif [[ "${FILE_[i]}"_64 == ${appsn[2]}_141_64 ]]; then
						KERNEL=ft.C.x
					elif [[ "${FILE_[i]}"_64 == ${appsn[3]}_151_64 ]]; then
						KERNEL=is.C.x
					elif [[ "${FILE_[i]}"_64 == ${appsn[0]}_161_64 ]]; then
						KERNEL=is.C.x
					elif [[ "${FILE_[i]}"_64 == ${appsn[1]}_171_64 ]]; then
						KERNEL=is.C.x
					elif [[ "${FILE_[i]}"_64 == ${appsn[0]}_181_64 ]]; then
						KERNEL=ft.C.x
					elif [[ "${FILE_[i]}"_64 == ${appsn[1]}_191_64 ]]; then
						KERNEL=ft.C.x
					elif [[ "${FILE_[i]}"_64 == ${appsn[0]}_201_64 ]]; then
						KERNEL=bt.C.x
					elif [[ "${FILE_[i]}"_64 == ${appsn[1]}_211_64  ]]; then
						KERNEL=sp.C.x
					elif [[ "${FILE_[i]}"_64 == ${appsn[0]}_221_64  ]]; then
						KERNEL=sp.C.x
					elif [[ "${FILE_[i]}"_64 == ${appsn[1]}_231_64  ]]; then
						KERNEL=bt.C.x
					fi

					date
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np 64 \
							-machinefile $MACHINEFILE \
							"$BENCHMARKS/$APP_BIN_NPBE"$KERNEL
					done
				fi	
			done
		done	
