#!/bin/bash

#############################################################################################################
##################################Step 1: Defining the Variables#############################################
#############################################################################################################

#Variable Directories
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
APP_BIN_NPBE=$NPBE/NPB3.4-MPI/bin
APP_CONFIG_NPBE=$NPBE/NPB3.4-MPI/config
APP_COMPILE_NPBE=$NPBE/NPB3.4-MPI

#Other Variables
BOND=802.3ad-4NICs-layer2
START=`date +"%d-%m-%Y.%Hh%Mm%Ss"`
OUTPUT_APPS_EXEC=$LOGS/apps_exec.$START.csv
PARTITION=(LACP20 LACP30 LACP40)

#############################################################################################################
#######################Step 2: Create the Folders/Download and Compile the Programs##########################
#############################################################################################################

mkdir -p $BASE/LOGS/SYS_INFO
mkdir -p $BENCHMARKS
mkdir -p $LOGS
mkdir -p $BASE/LOGS/LOGS_BACKUP
mkdir -p $LOGS_DOWNLOAD
mkdir -p $LOGS_BACKUP_SRC_CODE

#############################################################################################################
#################################Step 3: Collect the System Information######################################
#############################################################################################################

#######################################NPB##################################################
for (( i = 0; i < 3; i++ )); do
	ssh ${PARTITION[i]} 'nohup /home/lacp/NEWP/SH/benchmark.sh > benchmark.log' > /dev/null 2>&1 &
done                           
#######################################NPB##################################################
cd $BENCHMARKS
wget -c https://www.nas.nasa.gov/assets/npb/NPB3.4.1.tar.gz -S -a $LOGS_DOWNLOAD/NPB3.4.1_$INSTANCE.download.log
cp -r NPB3.4.1.tar.gz $LOGS_BACKUP_SRC_CODE; mv $LOGS_BACKUP_SRC_CODE/NPB3.4.1.tar.gz $LOGS_BACKUP_SRC_CODE/NPB3.4.1_$INSTANCE.tar.gz
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

#############################################################################################################
#######################Step 4: Define the Machine Files and Experimental Project#############################
#############################################################################################################

#Define the machine file and experimental project
if [[ $HOSTNAME == LACP10 ]]; then
	MACHINEFILE16=$MACHINE_FILES/nodes16_LACP10
	MACHINEFILE64=$MACHINE_FILES/nodes64_LACP10
elif [[ $HOSTNAME == LACP20  ]]; then
	MACHINEFILE16=$MACHINE_FILES/nodes16_LACP20
	MACHINEFILE64=$MACHINE_FILES/nodes64_LACP20
elif [[ $HOSTNAME == LACP30  ]]; then
	MACHINEFILE16=$MACHINE_FILES/nodes16_LACP30
	MACHINEFILE64=$MACHINE_FILES/nodes64_LACP30
elif [[ $HOSTNAME == LACP40  ]]; then
	MACHINEFILE16=$MACHINE_FILES/nodes16_LACP40
	MACHINEFILE64=$MACHINE_FILES/nodes64_LACP40
fi
PROJECT=$MACHINE_FILES/experimental_project.csv

#############################################################################################################
#######################Step 5: Read the Experimental Project and Started the Execution Loop##################
#############################################################################################################

#Read the experimental project
tail -n +2 $PROJECT |
while IFS=, read -r number apps process
do

	#Define a single key
	KEY="$number-$apps-$process"
	echo ""
	echo $KEY
	echo ""


#Create the Output to the other clusters
	if [[ $apps == is && $number == 1 ]]; then
			touch $HOME/exp/is_1_16
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == ft && $number == 31 ]]; then
			touch $HOME/exp/ft_31_16
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == is && $number == 61 ]]; then
			touch $HOME/exp/is_61_16
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == ft && $number == 91 ]]; then
			touch $HOME/exp/ft_91_16
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == bt && $number == 121 ]]; then
			touch $HOME/exp/bt_121_16
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == sp && $number == 151 ]]; then
			touch $HOME/exp/sp_151_16
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == bt && $number == 181 ]]; then
			touch $HOME/exp/bt_181_16
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done
	
	elif [[ $apps == sp && $number == 211 ]]; then
			touch $HOME/exp/sp_211_16
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == bt && $number == 241 ]]; then
			touch $HOME/exp/bt_241_16
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == sp && $number == 271 ]]; then
			touch $HOME/exp/sp_271_16
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done
			
	elif [[ $apps == bt && $number == 301 ]]; then
			touch $HOME/exp/bt_301_16
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == sp && $number == 331 ]]; then
			touch $HOME/exp/sp_331_16
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done
		
	elif [[ $apps == is && $number == 361 ]]; then
			touch $HOME/exp/is_361_64
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done
		
	elif [[ $apps == ft && $number == 391 ]]; then
			touch $HOME/exp/ft_391_64
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done
		
	elif [[ $apps == is && $number == 421 ]]; then
			touch $HOME/exp/is_421_64
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == ft && $number == 451 ]]; then
			touch $HOME/exp/ft_451_64
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == bt && $number == 481 ]]; then
			touch $HOME/exp/bt_481_64
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == sp && $number == 511 ]]; then
			touch $HOME/exp/sp_511_64
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == bt && $number == 541 ]]; then
			touch $HOME/exp/bt_541_64
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == sp && $number == 571 ]]; then
			touch $HOME/exp/sp_571_64
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == bt && $number == 601 ]]; then
			touch $HOME/exp/bt_601_64
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == sp && $number == 631 ]]; then	
			touch $HOME/exp/sp_631_64
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == bt && $number == 661 ]]; then
			touch $HOME/exp/bt_661_64
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done

	elif [[ $apps == sp && $number == 691 ]]; then
			touch $HOME/exp/sp_691_64
			for (( i = 0; i < 3; i++ )); do
				nohup $HOME/NEWP/SH/call.sh
			done		
		fi

#Prepare the command for execution
	runline=""
	runline+="mpiexec --mca btl self,tcp --mca btl_tcp_if_include eth0 "
	
	PROCS=$process
	
	runline+="-np $PROCS" 
	
	if [[ $process == 16 ]]; then
	runline+=" -machinefile $MACHINEFILE16 "	
	else
	runline+=" -machinefile $MACHINEFILE64 "			
	fi
	
	runline+="$BENCHMARKS/$APP_BIN_NPBE/$apps.C.x "
	runline+="2>> $LOGS/apps_exec_std_error "
	runline+="&> >(tee -a $LOGS/LOGS_BACKUP/$apps.$BOND.log > /tmp/nas.out)"	


#Execute the experiments
cd $DIR
aps16=(is_1 ft_31 is_61 ft_91 bt_121 sp_151 bt_181 sp_211 bt_241 sp_271 bt_301 sp_331)
aps64=(is_361 ft_391 is_421 ft_451 bt_481 sp_511 bt_541 sp_571 bt_601 sp_631 bt_661 sp_691)
c=2

	if [[ $process == 16 ]]; then
		for (( p = 0; p < 12; p++ )); do
            app_number16=${aps16[p]}
            if [[ -e ${app_number16}\_16 ]]; then                                        #               while [[ $c<5 ]]; do
      	       	while [[ $c<5 ]]; do
        	       	if [[ -e slave"$c"ok ]]; then
        	       	    rm -rf slave"$c"ok
                        let c++
                	fi
        	    done	
            fi
        done

    elif [[ $process == 64 ]]; then
        for (( p = 0; p < 12; p++ )); do
        	app_number64=${aps64[p]}
        	if [[ -e ${app_number64}\_64 ]]; then
        		while [[ $c<5 ]]; do
        	       	if [[ -e slave"$c"ok ]]; then
        	       	    rm -rf slave"$c"ok
                        let c++
                	fi
        	    done
        		fi	
        done
    fi

apsdel16=(is_30 ft_60 is_90 ft_120 bt_150 sp_180 bt_210 sp_240 bt_270 sp_300 bt_330 sp_360)
apsdel64=(is_361 ft_391 is_421 ft_451 bt_481 sp_511 bt_541 sp_571 bt_601 sp_631 bt_661 sp_691)
	
		if [[ $process == 16 ]]; then
			for (( d = 0; d < 12; d++ )); do
			apsdeln=${apsdel16[d]}
				for (( p = 0; p < 12; p++ )); do
					app_numberdel16=${aps16[p]}
						if [[ $apsdeln == $apps\_$number ]]; then
							rm $app_number\_16
						fi			
				done
			done
		elif [[ $process == 16 ]]; then
			for (( d = 0; d < 12; d++ )); do
			apsdeln=${apsdel64[d]}
				for (( p = 0; p < 12; p++ )); do
					app_numberdel64=${aps64[p]}
						if [[ $apsdeln == $apps\_$number ]]; then
							rm $app_number\_64
						fi			
				done
			done
		fi

	date
	echo "Executing >> $runline <<"
	eval "$runline < /dev/null"
	
	TIME=`grep -i "Time in seconds" /tmp/nas.out | awk {'print $5'}`
	echo "$apps,$BOND,$TIME" >> $OUTPUT_APPS_EXEC

	echo "Done!"
done
sed -i '1s/^/apps,bondmode,time\n/' $OUTPUT_APPS_EXEC
exit