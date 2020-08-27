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

#NPB Variables
NPBE=NPB3.4
APP_BIN_NPBE=$NPBE/NPB3.4-MPI/bin
APP_CONFIG_NPBE=$NPBE/NPB3.4-MPI/config
APP_COMPILE_NPBE=$NPBE/NPB3.4-MPI

#Alya Exec Variables
ALYAE=alya
ALYAE_DIR=$ALYAE/Executables/unix
APP_BIN_ALYAE=$ALYAE_DIR/Alya.x
APP_CONFIG_ALYAE=$ALYAE/Executables/unix/config.in
APP_ALYAE_TUFAN=$ALYAE/4_tufan_run/c/c
ALYAE_LOG=$APP_ALYAE_TUFAN.log

#Intel MPI Benchmarks Variables
INTEL=mpi-benchmarks
INTEL_SOURCE=$INTEL/src_cpp/Makefile
APP_BIN_INTEL=$INTEL/IMB-MPI1
APP_TEST_INTEL=PingPong

#Other Variables
BOND=Regular-TCP-4NICs
START=`date +"%d-%m-%Y.%Hh%Mm%Ss"`
OUTPUT_APPS_EXEC=$LOGS/apps_exec.$START.csv
OUTPUT_INTEL_EXEC=$LOGS/intel.$START.csv
CONTROL_FILE_OUTPUT=$BASE/LOGS/env_info.org
PARTITION=(ONE1 ONE2 ONE3 ONE4)

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

echo "#+TITLE: System Information" >> $CONTROL_FILE_OUTPUT
echo "#+DATE: $(eval date)" >> $CONTROL_FILE_OUTPUT
echo "#+AUTHOR: $(eval whoami)" >> $CONTROL_FILE_OUTPUT
echo "#+MACHINE: $(eval hostname)" >> $CONTROL_FILE_OUTPUT
echo "#+FILE: $(eval basename $CONTROL_FILE_OUTPUT)" >> $CONTROL_FILE_OUTPUT
echo "" >> $CONTROL_FILE_OUTPUT

#Executes the system information collector script
for (( i = 0; i < 4; i++ )); do
	ssh ${PARTITION[i]} '/home/lacp/NEWP/SH/./sys_info_collect.sh'
done


########################################Alya################################################
#Exec
cd $BENCHMARKS
appsa=alya
git clone --recursive --progress https://gitlab.com/ammaliszewski/alya.git 2> $LOGS_DOWNLOAD/Alya_$instance.download.log
cp -r alya $LOGS_BACKUP_SRC_CODE
tar -zcvf $LOGS_BACKUP_SRC_CODE/Alya_$instance.tar.gz $LOGS_BACKUP_SRC_CODE/alya
rm -rf $LOGS_BACKUP_SRC_CODE/alya;
cd $ALYAE_DIR
cp configure.in/config_gfortran.in config.in
sed -i 's,mpif90,mpifort,g' config.in
./configure -x nastin parall
make metis4; make

#######################################NPB##################################################
#Exec
cd $BENCHMARKS
wget -c https://www.nas.nasa.gov/assets/npb/NPB3.4.tar.gz -S -a $LOGS_DOWNLOAD/NPB3.4_$INSTANCE.download.log
cp -r NPB3.4.tar.gz $LOGS_BACKUP_SRC_CODE; mv $LOGS_BACKUP_SRC_CODE/NPB3.4.tar.gz $LOGS_BACKUP_SRC_CODE/NPB3.4_$INSTANCE.tar.gz
tar -xzf NPB3.4.tar.gz
rm -rf NPB3.4.tar.gz

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

#################################Intel MPI Benchmarks#############################################
cd $BENCHMARKS
appsi=intel
git clone --recursive --progress https://github.com/intel/mpi-benchmarks.git 2> $LOGS_DOWNLOAD/mpi-benchmarks.download.log
cp -r mpi-benchmarks $LOGS_BACKUP_SRC_CODE
sed -i 's,mpiicc,mpicc,g' $INTEL_SOURCE
sed -i 's,mpiicpc,mpicxx,g' $INTEL_SOURCE
cd $INTEL; make IMB-MPI1
cd $BASE

#############################################################################################################
#######################Step 4: Define the Machine Files and Experimental Project#############################
#############################################################################################################

#Define the machine file and experimental project
MACHINEFILE=$MACHINE_FILES/nodes
MACHINEFILE_INTEL=$MACHINE_FILES/nodes_intel
PROJECT=$MACHINE_FILES/experimental_project.csv

for (( i = 0; i < 30; i++ )); do
	echo $appsi >> /tmp/expd
	echo $appsa >> /tmp/expd
	for (( n = 0; n < 4; n++ )); do
		echo ${appsn[n]} >> /tmp/expd
	done
done

shuf /tmp/expd -o /tmp/exp
awk '{print NR "," $0} END{print ""}' /tmp/exp > $MACHINE_FILES/experimental_project.csv
sed -i '1s/^/number,apps\n/' $PROJECT
rm /tmp/expd /tmp/exp 

scp -r $HOME/NEWP ONE2:/home/lacp
scp -r $HOME/NEWP ONE3:/home/lacp
scp -r $HOME/NEWP ONE4:/home/lacp

#############################################################################################################
#######################Step 5: Read the Experimental Project and Started the Execution Loop##################
#############################################################################################################

#Read the experimental project
tail -n +2 $PROJECT |
while IFS=, read -r number apps 
do

#Define a single key
	KEY="$number-$apps"
	echo ""
	echo $KEY
	echo ""

#Prepare the command for execution
	runline=""
	runline+="mpiexec --mca btl self,tcp --mca btl_tcp_if_include eth0 "
	
#Select app
	if [[ $apps == intel ]]; then
		PROCS=2
		runline+="-np $PROCS -machinefile $MACHINEFILE_INTEL "
	else
		PROCS=16
		runline+="-np $PROCS -machinefile $MACHINEFILE "
	fi

#Save the output according to the app
	if [[ $apps == intel ]]; then
		runline+="$BENCHMARKS/$APP_BIN_INTEL $APP_TEST_INTEL "
		runline+="2>> $LOGS/apps_exec_std_error "
		runline+="&> >(tee -a $LOGS/LOGS_BACKUP/$apps.$BOND.log > /tmp/intel_mb.out)"
	elif [[ $apps == alya ]]; then
                runline+="$BENCHMARKS/$APP_BIN_ALYAE BENCHMARKS/$APP_ALYAE_TUFAN "
                runline+="2 >> $LOGS/apps_exec_std_error "
                runline+="&> >(tee -a $LOGS/LOGS_BACKUP/$apps_$BOND.log > /tmp/alya.out)"
	else
		runline+="$BENCHMARKS/$APP_BIN_NPBE/$apps.C.x "
		runline+="2>> $LOGS/apps_exec_std_error "
		runline+="&> >(tee -a $LOGS/LOGS_BACKUP/$apps.$BOND.log > /tmp/nas.out)"	
	fi	

#Execute the experiments
	echo "Executing >> $runline <<"
	eval "$runline < /dev/null"
	
	#Save the output according to the app
	if [[ $apps == intel ]]; then
		N=`tail -n +35 /tmp/intel_mb.out | awk {'print $1'} | grep -v '[^ 0.0-9.0]' | sed '/^[[:space:]]*$/d' | wc -l`
		for (( i = 0; i < $N; i++ )); do
			echo "$apps,$BOND" >> /tmp/for.out
		done

		tail -n +35 /tmp/intel_mb.out | awk {'print $1'} | grep -v '[^ 0.0-9.0]' | sed '/^[[:space:]]*$/d' > /tmp/BYTES
    	tail -n +35 /tmp/intel_mb.out | awk {'print $3'} | grep -v '[^ 0.0-9.0]' | sed '/^[[:space:]]*$/d' > /tmp/TIME
    	tail -n +35 /tmp/intel_mb.out | awk {'print $4'} | grep -v '[^ 0.0-9.0]' | sed '/^[[:space:]]*$/d' > /tmp/Mbytes
    	paste -d"," /tmp/for.out /tmp/BYTES /tmp/TIME /tmp/Mbytes >> $OUTPUT_INTEL_EXEC
    	rm /tmp/for.out; rm /tmp/BYTES; rm /tmp/TIME; rm /tmp/Mbytes	
	
	elif [[ $apps == alya ]]; then
                TIME=`cat $BENCHMARKS/$ALYAE_LOG | grep "TOTAL CPU TIME" | awk '{print $4}'`
                echo "$apps,$BOND,$TIME" >> $OUTPUT_APPS_EXEC
	else
		TIME=`grep -i "Time in seconds" /tmp/nas.out | awk {'print $5'}`
		echo "$apps,$BOND,$TIME" >> $OUTPUT_APPS_EXEC
	fi

	echo "Done!"
done
sed -i '1s/^/apps,bondmode,time\n/' $OUTPUT_APPS_EXEC
sed -i '1s/^/apps,bondmode,bytes,time,mbytes-sec\n/' $OUTPUT_INTEL_EXEC

exit
