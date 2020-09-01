/* The densities are numbered as follows:
 *               6   2   5
 *                 \ | /
 *               3 - 0 - 1
 *                 / | \
 *               7   4   8
 *
 * The lattice nodes are numbered as follows:
 *      ^
 *      |
 *      y
 *           :    :    :
 *
 *      3    *    *    *  ..
 *
 *           *    *    *  ..
 *
 *      1    *    *    *  ..
 *                            x ->
 *           1    2    3 
 *      
*/


///////////////////////////////////////////////
//libraries
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <sys/time.h>

typedef enum {false, true} bool;
typedef char *string;

int numprocs; //number of processors
int myid; // processor identification


///////////////////////////////////////////////
//structs

//struct contends macroscopic information
typedef struct{
	int t_max; //Maximum number of iterations
	double density; //Fluid density per link
	double accel; //Accelleration
	double omega; //Relaxation parameter
	double r_rey; //Linear dimension for Reynolds number
} s_properties;

//lattice structure
typedef struct {
	int lx_first; //initial position of the sub-lattice
	int lx_last; //final position of the sub-lattice
	int lx; //vertex number in axis x
	int ly; //vertex number in axis y
	int n; //lattice dimension - number of directions
	bool **obst; //obstacle Array lx * ly
	double ***node; //n-speed lattice  n * lx * ly
	double ***temp; //temporarely storage of fluid densities
} s_lattice;


///////////////////////////////////////////////
//Functions

s_properties* read_parametrs(string file);

void alloc_lattice(s_lattice *l);

s_lattice* read_obstacles(string file);

void init_density(s_lattice * l, double density);

void check_density(s_lattice *l, int time);

void redistribute(s_lattice *l, double accel, double density);

void redistribute_p(s_lattice *l, double accel, double density);

void propagate(s_lattice *l);

void bounceback(s_lattice *l);

void relaxation(s_lattice *l, double density, double omega);

double calc_velocity(s_lattice *l, int time);

double calc_velocity_p(s_lattice *l, int time);

void write_results(string file, s_lattice *l, double density);

void comp_rey(s_lattice *l, s_properties *p, int time, double comm, double execution, int numprocs); 

double crono();

void change_lattice(s_lattice *lattice, double * buf, int x);


