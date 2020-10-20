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
MACHINEFILE16=$MACHINE_FILES/nodes16_$HOSTNAME
MACHINEFILE64=$MACHINE_FILES/nodes64_$HOSTNAME
NPBE=NPB3.4.1
APP_BIN_NPBE=$NPBE/NPB3.4-MPI/bin/
app_procs=(is_1 ft_31 is_61 ft_91 bt_121 sp_151 bt_181 sp_211 bt_241 sp_271 bt_301 sp_331)

cd $DIR

for (( a = 0; a < 12; a++ )); do
	app_proc=${app_procs[a]}
	while [[ $c < 2 ]]; do
		if [[ -e $app_proc\_16 ]]; then
			let c++
		elif [[ -e $app_proc\_64 ]]; then
			let c++
		fi
	done
done


for (( p = 0; p < 2; p++ )); do
	processes=${processesn[p]}
	for (( n = 0; n < 4; n++ )); do
		app=${appsn[n]}
			for i in {1..331..30}; do 
				FILE_[$i]="$app"_"$i"
				if [[ -e "${FILE_[i]}"_$processes ]]; then
					touch $slaveok
					touch teste
					#rm -rf  "${FILE_[i]}"_$processes
					while [[ true ]]; do
					if [[ "${FILE_[i]}"_$processes == ${appsn[2]}_1_16 ]]; then
						KERNEL=is.C.x
						MACHINEFILE=$MACHINEFILE16
					elif [[ "${FILE_[i]}"_$processes == ${appsn[3]}_31_16 ]]; then
						KERNEL=ft.C.x
						MACHINEFILE=$MACHINEFILE16
					elif [[ "${FILE_[i]}"_$processes == ${appsn[2]}_61_16 ]]; then
						KERNEL=ft.C.x
						MACHINEFILE=$MACHINEFILE16
					elif [[ "${FILE_[i]}"_$processes == ${appsn[3]}_91_16 ]]; then
						KERNEL=is.C.x
						MACHINEFILE=$MACHINEFILE16
					elif [[ "${FILE_[i]}"_$processes == ${appsn[0]}_121_16 ]]; then
						KERNEL=is.C.x
						MACHINEFILE=$MACHINEFILE16
					elif [[ "${FILE_[i]}"_$processes == ${appsn[1]}_151_16 ]]; then
						KERNEL=is.C.x
						MACHINEFILE=$MACHINEFILE16
					elif [[ "${FILE_[i]}"_$processes == ${appsn[0]}_181_16 ]]; then
						KERNEL=ft.C.x
						MACHINEFILE=$MACHINEFILE16
					elif [[ "${FILE_[i]}"_$processes == ${appsn[1]}_211_16 ]]; then
						KERNEL=ft.C.x
						MACHINEFILE=$MACHINEFILE16
					elif [[ "${FILE_[i]}"_$processes == ${appsn[0]}_241_16 ]]; then
						KERNEL=bt.C.x
						MACHINEFILE=$MACHINEFILE16
					elif [[ "${FILE_[i]}"_$processes == ${appsn[1]}_271_16  ]]; then
						KERNEL=sp.C.x
						MACHINEFILE=$MACHINEFILE16
					elif [[ "${FILE_[i]}"_$processes == ${appsn[0]}_301_16  ]]; then
						KERNEL=sp.C.x
						MACHINEFILE=$MACHINEFILE16
					elif [[ "${FILE_[i]}"_$processes == ${appsn[1]}_331_16  ]]; then
						KERNEL=bt.C.x
						MACHINEFILE=$MACHINEFILE16
					elif [[ "${FILE_[i]}"_$processes == ${appsn[2]}_1_64 ]]; then
						KERNEL=is.C.x
						MACHINEFILE=$MACHINEFILE64
					elif [[ "${FILE_[i]}"_$processes == ${appsn[3]}_31_64 ]]; then
						KERNEL=ft.C.x
						MACHINEFILE=$MACHINEFILE64
					elif [[ "${FILE_[i]}"_$processes == ${appsn[2]}_61_64 ]]; then
						KERNEL=ft.C.x
						MACHINEFILE=$MACHINEFILE64
					elif [[ "${FILE_[i]}"_$processes == ${appsn[3]}_91_64 ]]; then
						KERNEL=is.C.x
						MACHINEFILE=$MACHINEFILE64
					elif [[ "${FILE_[i]}"_$processes == ${appsn[0]}_121_64 ]]; then
						KERNEL=is.C.x
						MACHINEFILE=$MACHINEFILE64
					elif [[ "${FILE_[i]}"_$processes == ${appsn[1]}_151_64 ]]; then
						KERNEL=is.C.x
						MACHINEFILE=$MACHINEFILE64
					elif [[ "${FILE_[i]}"_$processes == ${appsn[0]}_181_64 ]]; then
						KERNEL=ft.C.x
						MACHINEFILE=$MACHINEFILE64
					elif [[ "${FILE_[i]}"_$processes == ${appsn[1]}_211_64 ]]; then
						KERNEL=ft.C.x
						MACHINEFILE=$MACHINEFILE64
					elif [[ "${FILE_[i]}"_$processes == ${appsn[0]}_241_64 ]]; then
						KERNEL=bt.C.x
						MACHINEFILE=$MACHINEFILE64
					elif [[ "${FILE_[i]}"_$processes == ${appsn[1]}_271_64  ]]; then
						KERNEL=sp.C.x
						MACHINEFILE=$MACHINEFILE64
					elif [[ "${FILE_[i]}"_$processes == ${appsn[0]}_301_64  ]]; then
						KERNEL=sp.C.x
						MACHINEFILE=$MACHINEFILE64
					elif [[ "${FILE_[i]}"_$processes == ${appsn[1]}_331_64  ]]; then
						KERNEL=bt.C.x
						MACHINEFILE=$MACHINEFILE64
					fi	
					date
					mpiexec --mca btl self,tcp \
							--mca btl_tcp_if_include eth0 \
							-np $processesn \
							-machinefile $MACHINEFILE \
							"$BENCHMARKS/$APP_BIN_NPBE"$KERNEL
					done
			fi
		done
	done
done
