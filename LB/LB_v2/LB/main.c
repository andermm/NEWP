#include "lb.h"

//Define to each node the first and the last position of the sublattice
void define_sublattice(s_lattice *lattice, int numprocs) {
	int size = lattice->lx/numprocs;
	//begin sublattice
	lattice->lx_first = size * myid;
	//end sublattice
	if (myid == numprocs -1) 
		lattice->lx_last = lattice->lx;
	else
		lattice->lx_last = size * (myid + 1);
}


//Define element type
void define_type(s_lattice *lattice, MPI_Datatype *element_type) {
	MPI_Type_contiguous(lattice->n, MPI_DOUBLE, element_type);
	MPI_Type_commit(element_type);
}


//Define lengths
int * define_lengths(s_lattice *lattice) {
	int i;
	int *b_length = (int*) malloc(lattice->ly*sizeof(int)); 
	for (i=0; i < lattice->ly; i++) //initialize the vector
		b_length[i] = 1; //size of each block
	return b_length;
}


//Extended a datatype
MPI_Aint *define_old(s_lattice *lattice) {
	MPI_Aint sizeint; //Address argument 
	MPI_Type_extent(MPI_INT, &sizeint); //Extended datatype
	return (MPI_Aint*) malloc(lattice->ly * sizeint);
}


//Define a datatype for first column of a sublattice
MPI_Aint *define_old_type_first(s_lattice *lattice) {
	int base; //to decrease disp
	int i; //counter
	MPI_Aint *disp = define_old(lattice);
	for (i = 0; i < lattice->ly; i++)
		MPI_Address(lattice->node[lattice->lx_first][i], &disp[i]);
	base = disp[0];
	for (i = 0; i <lattice->ly; i++)
		disp[i] -= base;
	return disp;
}


//Define a datatype for last column of a sublattice
MPI_Aint *define_old_type_last(s_lattice *lattice) {
	int base; //to decrease disp
	int i; //counter
	MPI_Aint *disp = define_old(lattice);
	for (i = 0; i < lattice->ly; i++)
		MPI_Address(lattice->node[lattice->lx_last - 1][i], &disp[i]);
	base = disp[0];
	for (i = 0; i <lattice->ly; i++)
		disp[i] -= base;
	return disp;
}


//Send limits regions to neighbor processors
void sincronization(s_lattice *lattice, double *buf_node, MPI_Datatype column_first_type, MPI_Datatype column_last_type, int numprocs) {
	//local variable
	MPI_Status status;

	//send first column
	MPI_Send(lattice->node[lattice->lx_first][0], 1, column_first_type, (myid - 1 + numprocs)%numprocs, 1, MPI_COMM_WORLD);
	//send last column
	MPI_Send(lattice->node[lattice->lx_last-1][0], 1, column_last_type, ((myid + 1)%numprocs), 2, MPI_COMM_WORLD);

	//receive to complete last column
	MPI_Recv(buf_node,lattice->ly*lattice->n, MPI_DOUBLE, (myid + 1)%numprocs, 1, MPI_COMM_WORLD,&status);
	change_lattice(lattice, buf_node, (lattice->lx_last)%lattice->lx);
	//receive to complete first column
	MPI_Recv(buf_node, lattice->ly*lattice->n, MPI_DOUBLE, (myid - 1 + numprocs)%numprocs, 2, MPI_COMM_WORLD, &status);
	change_lattice(lattice, buf_node, (lattice->lx_first - 1 + lattice->lx)%lattice->lx);
}


///////////////////////////////////////////////
int main(int argc, char **argv) {
	
	//Parameters
	extern int myid;
	extern int numprocs;
	MPI_Datatype column_first_type;
	MPI_Datatype column_last_type;
	
	//Buffer
	double *buf_node; 
	
	//Iteration counter
	int time;
	
	//Time counters
	double start_time;
	double start_comm;
	double end_time;
	double time_comm;

	//Average velocity
	//double vel;

	//Input structure
	s_properties *properties;

	//Lattice structure
	s_lattice *lattice;

	//startup information message	
	/* printf("Lattice Boltzmann Method\n");
	printf("Claudio Schepke\n");
	printf("Instituto de Informática - UFRGS\n");
	printf("Date: 2006, January 09\n\n"); */
	
	//Checking arguments
	/* if (argc != 4) {
		fprintf(stderr, "Usage: %s [file_configuration] [file_colision] [file_plot]\n\n", argv[0]);
		exit(1);
	}*/
	
	//Begin MPI initialization
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
	//x- and y-coordinates of any obstacles
	//wall boundaries are also defined here by adding single obstacles
	lattice = (s_lattice*) read_obstacles(argv[2]);
	
	//Initialize Density
	init_density(lattice, properties->density);

	//Define to each node the first and the last position of the sublattice
	define_sublattice(lattice, numprocs);


	//Define a MPI struct to send vector borders between sublattices
	
	//configure element_type
	MPI_Datatype *element_type;
	define_type(lattice, element_type);
	
	//configuring b_length, a struct for a lattice line (vector)
	int *b_length = define_lengths(lattice); 

	//configuring disp
	MPI_Aint *disp = define_old_type_first(lattice); //Address argument for a vector		
	// create the datatype for first column
	MPI_Type_hindexed(lattice->ly, b_length, disp, *element_type, &column_first_type);
	MPI_Type_commit(&column_first_type);

	//configuring disp
	disp = define_old_type_last(lattice);
	//create datatype for last column
	MPI_Type_hindexed(lattice->ly, b_length, disp, *element_type, &column_last_type);
	MPI_Type_commit(&column_last_type);
	
	//free memory allocation
	free(b_length);
	free(disp); 


	//alocation buffer for communication
	buf_node = (double*)malloc(lattice->ly*lattice->n*sizeof(double));

	//Begin timer
	if (myid == numprocs/2)
		start_time = MPI_Wtime();

	//Begin of the main loop
	for (time = 0; time < properties->t_max; time++) {

		redistribute_p(lattice, properties->accel, properties->density);
		
		propagate(lattice);
		
		bounceback(lattice);
		
		relaxation(lattice, properties->density, properties->omega);
		
		//Communications
		start_comm = MPI_Wtime();
		sincronization(lattice, buf_node, column_first_type, column_last_type, numprocs);
		time_comm = MPI_Wtime() - start_comm;

		//Calcule velocity
		//vel = calc_velocity_p(lattice, time);
	}
	
	//End counter
	if (myid == numprocs/2)
		end_time = MPI_Wtime();
	
	//Macroscopic properties and time resume
	if (myid == numprocs/2) {
		comp_rey(lattice, properties, time, time_comm, end_time - start_time, numprocs);
		//write_results(argv[3], lattice, properties->density);
	}
	
	MPI_Finalize();
	//printf("End of the execution\n\n");
	return 1;
}
