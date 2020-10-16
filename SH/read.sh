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

mkdir -p $BENCHMARKS

#Kill processes
#kill -15 -1

#Exec
cd $BENCHMARKS
wget -c https://www.nas.nasa.gov/assets/npb/NPB3.4.1.tar.gz 
tar -xzf NPB3.4.1.tar.gz
rm -rf NPB3.4.1.tar.gz

for f in $APP_CONFIG_NPBE/*.def.template; do
        mv -- "$f" "${f%.def.template}.def";
done

sed -i 's,mpif90,mpifort,g' $APP_CONFIG_NPBE/make.def
appsn=(bt sp is ft)
classes=(C)
echo -n "" > $APP_CONFIG_NPBE/suite.def

for (( n = 0; n < 4; n++ )); do
        for (( i = 0; i < 1; i++ )); do
                echo -e ${appsn[n]}"\t"${classes[i]} >> $APP_CONFIG_NPBE/suite.def
        done
done
cd $APP_COMPILE_NPBE; make suite

####################################################################################################################

cd $DIR

for (( p = 0; p < 2; p++ )); do
	processes=${processesn[p]}
	for (( n = 0; n < 4; n++ )); do
		app=${appsn[n]}
			for i in {1..331..30}; do 
				FILE_[$i]="$app"_"$i"
				if [[ -e "${FILE_[i]}"_$processes ]]; then
					touch $slaveok
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
