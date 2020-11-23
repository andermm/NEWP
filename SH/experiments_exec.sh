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
MACHINEFILE16=$MACHINE_FILES/nodes16_${HOSTNAME}
MACHINEFILE64=$MACHINE_FILES/nodes64_${HOSTNAME}

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
			nohup $HOME/NEWP/SH/call.sh

	elif [[ $apps == ft && $number == 11 ]]; then
			touch $HOME/exp/ft_11_16
			nohup $HOME/NEWP/SH/call.sh

	elif [[ $apps == is && $number == 21 ]]; then
			touch $HOME/exp/is_21_16
			nohup $HOME/NEWP/SH/call.sh

	elif [[ $apps == ft && $number == 31 ]]; then
			touch $HOME/exp/ft_31_16
			nohup $HOME/NEWP/SH/call.sh

	elif [[ $apps == bt && $number == 41 ]]; then
			touch $HOME/exp/bt_41_16
			nohup $HOME/NEWP/SH/call.sh


	elif [[ $apps == sp && $number == 51 ]]; then
			touch $HOME/exp/sp_51_16
			nohup $HOME/NEWP/SH/call.sh


	elif [[ $apps == bt && $number == 61 ]]; then
			touch $HOME/exp/bt_61_16
			nohup $HOME/NEWP/SH/call.sh

	
	elif [[ $apps == sp && $number == 71 ]]; then
			touch $HOME/exp/sp_71_16
			nohup $HOME/NEWP/SH/call.sh


	elif [[ $apps == bt && $number == 81 ]]; then
			touch $HOME/exp/bt_81_16
			nohup $HOME/NEWP/SH/call.sh
		

	elif [[ $apps == sp && $number == 91 ]]; then
			touch $HOME/exp/sp_91_16
			nohup $HOME/NEWP/SH/call.sh
			
	elif [[ $apps == bt && $number == 101 ]]; then
			touch $HOME/exp/bt_101_16
			nohup $HOME/NEWP/SH/call.sh

	elif [[ $apps == sp && $number == 111 ]]; then
			touch $HOME/exp/sp_111_16
			nohup $HOME/NEWP/SH/call.sh
		
	elif [[ $apps == is && $number == 121 ]]; then
			touch $HOME/exp/is_121_64
			nohup $HOME/NEWP/SH/call.sh
		
	elif [[ $apps == ft && $number == 131 ]]; then
			touch $HOME/exp/ft_131_64
			nohup $HOME/NEWP/SH/call.sh
			
		
	elif [[ $apps == is && $number == 141 ]]; then
			touch $HOME/exp/is_141_64
			nohup $HOME/NEWP/SH/call.sh

	elif [[ $apps == ft && $number == 151 ]]; then
			touch $HOME/exp/ft_151_64
			nohup $HOME/NEWP/SH/call.sh

	elif [[ $apps == bt && $number == 161 ]]; then
			touch $HOME/exp/bt_161_64
			nohup $HOME/NEWP/SH/call.sh

	elif [[ $apps == sp && $number == 171 ]]; then
			touch $HOME/exp/sp_171_64
			nohup $HOME/NEWP/SH/call.sh

	elif [[ $apps == bt && $number == 181 ]]; then
			touch $HOME/exp/bt_181_64
			nohup $HOME/NEWP/SH/call.sh
			

	elif [[ $apps == sp && $number == 191 ]]; then
			touch $HOME/exp/sp_191_64
			nohup $HOME/NEWP/SH/call.sh

	elif [[ $apps == bt && $number == 201 ]]; then
			touch $HOME/exp/bt_201_64
			nohup $HOME/NEWP/SH/call.sh

	elif [[ $apps == sp && $number == 211 ]]; then	
			touch $HOME/exp/sp_211_64
			nohup $HOME/NEWP/SH/call.sh

	elif [[ $apps == bt && $number == 221 ]]; then
			touch $HOME/exp/bt_221_64
			nohup $HOME/NEWP/SH/call.sh

	elif [[ $apps == sp && $number == 231 ]]; then
			touch $HOME/exp/sp_231_64
			nohup $HOME/NEWP/SH/call.sh
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
aps16=(is_1 ft_11 is_21 ft_31 bt_41 sp_51 bt_61 sp_71 bt_81 sp_91 bt_101 sp_111)
aps64=(is_121 ft_131 is_141 ft_151 bt_161 sp_171 bt_181 sp_191 bt_201 sp_211 bt_221 sp_231)
c=2

	if [[ $process == 16 ]]; then
		for (( p = 0; p < 12; p++ )); do
            app_number16=${aps16[p]}
            if [[ -e ${app_number16}\_16 ]]; then                                        
      	       	while [[ $c<5 ]]; do
        	       	if [[ -e slave"$c"ok ]]; then
        	       	    rm -rf slave"$c"ok
                        let c++
                	fi
        	    done	
            fi
            rm $app_number16\_16
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
        	rm $app_number64\_64	
        done
    fi

	date
	echo "Executing >> $runline <<"
	eval "$runline < /dev/null"
	
	TIME=`grep -i "Time in seconds" /tmp/nas.out | awk {'print $5'}`
	echo "$apps,$process,$BOND,$TIME" >> $OUTPUT_APPS_EXEC

	echo "Done!"
done
sed -i '1s/^/apps,process,bondmode,time\n/' $OUTPUT_APPS_EXEC
exit