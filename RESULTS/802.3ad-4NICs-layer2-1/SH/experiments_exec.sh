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

	date
	echo "Executing >> $runline <<"
	eval "$runline < /dev/null"
	
	TIME=`grep -i "Time in seconds" /tmp/nas.out | awk {'print $5'}`
	echo "$apps,$process,$BOND,$TIME" >> $OUTPUT_APPS_EXEC

	echo "Done!"
done
sed -i '1s/^/apps,process,bondmode,time\n/' $OUTPUT_APPS_EXEC
exit
