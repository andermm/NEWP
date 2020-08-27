#include "lb.h"

void change_lattice(s_lattice *lattice, double * buf, int x)
{
	int i,n;
	int k=0;
	for (i=0;i<lattice->ly;i++) {
		for (n=0; n< lattice->n;n++) {
			lattice->node[x][i][n] = buf[k];
			k++;
		}
	}
	return;
}

///////////////////////////////////////////////
int main(int argc, char **argv) {
	
	//Parameters
	
	extern int myid, numprocs;
	int i;
	int size;
	MPI_Status status;
	/*types to send the data */
	MPI_Datatype element_type;
	MPI_Datatype column_first_type;
	MPI_Datatype column_last_type;
	double * buf_node; //buffer
	MPI_Aint sizeint;
	int * b_length;
	int base;
	MPI_Aint * disp;

	//Iteration counter
	int time;

	//Average velocity
	double vel;

	//Input structure
	s_properties *properties;

	//Lattice structure
	s_lattice *lattice;

	//startup information message
	printf("Lattice Boltzmann Method\n");
	printf("Claudio Schepke\n");
	printf("Instituto de Informática - UFRGS\n");
	printf("Date: 2006, January 09\n\n\n");

	//Checking arguments
	if (argc != 4) {
		fprintf(stderr, "Usage: %s [file_configuration] [file_colision] [file_plot]\n\n", argv[0]);
		exit(1);
	}
	
	//Begin initialization
	MPI_Init(&argc,&argv);
	MPI_Comm_size(MPI_COMM_WORLD,&numprocs);
	MPI_Comm_rank(MPI_COMM_WORLD,&myid);
	//Read parameter file
	//properties->t_max
	//properties->density
	//properties->accel
	//properties->omega
	//properties->r_rey
	properties = (s_properties*) read_parametrs(argv[1]);

	//read obstacle file
	//<x> <y> <n directions> <number of obstacles> 
	//x-,and y-coordinates of any obstacles
	//wall boundaries are also defined here by adding single obstacles
	lattice = (s_lattice*) read_obstacles(argv[2]);
	lattice->lx_first=0;

	init_density(lattice, properties->density);

	size = lattice->lx/numprocs;
	for (i=0;i<numprocs;i++) {
		if (myid == i) {
			lattice->lx_first = size*i;
			if (myid==numprocs-1) 
				lattice->lx_last = lattice->lx;
			else
				lattice->lx_last = size*(i+1);
		}
	}
	//creating the datatypes
	MPI_Type_contiguous(lattice->n, MPI_DOUBLE, &element_type);
	MPI_Type_commit(&element_type);

	/* create the datatype for first column */
	b_length = (int*)malloc(lattice->ly*sizeof(int));
	for (i=0;i<lattice->ly;i++)
		b_length[i]=1;
	MPI_Type_extent(MPI_INT,&sizeint);
	disp = (int*)malloc(lattice->ly*sizeint);
	for (i=0;i<lattice->ly;i++)
		MPI_Address(lattice->node[lattice->lx_first][i], &disp[i]);
	base = disp[0];
	for (i=0; i <lattice->ly; i++) 
		disp[i] -= base;
	MPI_Type_hindexed(lattice->ly,b_length,disp,element_type,&column_first_type);
	MPI_Type_commit(&column_first_type);

	/*create datatype for last column*/
	for (i=0;i<lattice->ly;i++)
		MPI_Address(lattice->node[lattice->lx_last-1][i], &disp[i]);
	base = disp[0];
	for (i=0; i <lattice->ly; i++) 
		disp[i] -= base;
	MPI_Type_hindexed(lattice->ly,b_length,disp,element_type,&column_last_type);
	MPI_Type_commit(&column_last_type);
	free(b_length);
	free(disp);

	//alocation buffer
	buf_node = (double*)malloc(lattice->ly*lattice->n*sizeof(double));
	//first iteration loop

	if ((myid==0) || (myid==numprocs-1))
		redistribute(lattice, properties->accel, properties->density);
	propagate(lattice);
	bounceback(lattice);
	relaxation(lattice, properties->density, properties->omega);

 	if (myid==0) {
		MPI_Send(lattice->node[lattice->lx_first][0],1,column_first_type,numprocs-1,1,MPI_COMM_WORLD);
  	}
	else {
		MPI_Send(lattice->node[lattice->lx_first][0],1,column_first_type,myid-1,1,MPI_COMM_WORLD);
  	}
	MPI_Send(lattice->node[lattice->lx_last-1][0],1,column_last_type,((myid+1)%numprocs),2,MPI_COMM_WORLD);
	//Begin of the main loop
	for (time = 1; time < properties->t_max; time++) {
		/*
		if (!(time%(properties->t_max/10))) {
			check_density(lattice, time);
			}      */
		
		//receive the messages
		MPI_Recv(buf_node,lattice->ly*lattice->n,MPI_DOUBLE,(myid+1)%numprocs,1,MPI_COMM_WORLD,&status);
		change_lattice(lattice,buf_node,(lattice->lx_last)%lattice->lx);

		if (myid==0) {
			MPI_Recv(buf_node,lattice->ly*lattice->n,MPI_DOUBLE,numprocs-1,2,MPI_COMM_WORLD,&status);
			change_lattice(lattice,buf_node,lattice->lx-1);
		}
		else {
			MPI_Recv(buf_node,lattice->ly*lattice->n,MPI_DOUBLE,myid-1,2,MPI_COMM_WORLD,&status);
			change_lattice(lattice,buf_node,lattice->lx_first-1);
		}
		//start algorithm
		if ((myid==0) || (myid==numprocs-1) )
			redistribute(lattice, properties->accel, properties->density);
		propagate(lattice);
		bounceback(lattice);
		relaxation(lattice, properties->density, properties->omega);
		if (myid==(lattice->lx/2)/size) {
			vel = calc_velocity(lattice, time);
		}
		if (time == properties->t_max -1)
			break;
		if (myid==0) {
			MPI_Send(lattice->node[lattice->lx_first][0],1,column_first_type,numprocs-1,1,MPI_COMM_WORLD);
		}
		else {
			MPI_Send(lattice->node[lattice->lx_first][0],1,column_first_type,myid-1,1,MPI_COMM_WORLD);
		}
		MPI_Send(lattice->node[lattice->lx_last-1][0],1,column_last_type,((myid+1)%numprocs),2,MPI_COMM_WORLD);
	}

	write_results(argv[3], lattice, properties->density);
	if (myid==(lattice->lx/2)/size)
		comp_rey(lattice, properties->omega, properties->density, properties->r_rey, time);
	MPI_Finalize();
	printf("End of the execution\n\n");
	return 1;
}
