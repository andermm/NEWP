#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {

	//Checking arguments
	if (argc != 5) {
		fprintf(stderr, "Usage: %s [file_output] [size_x] [size_y] [size_z]\n\n", argv[0]);
		exit(1);
	}
	
	int i, j, k;
	int dim = 3;
	int n = 19;
	int min = 1;
	int max_x = atoi(argv[2]);
	int max_y = atoi(argv[3]);
	int max_z = atoi(argv[4]);
	int total = 2*(max_x * max_y + max_x * max_z) + max_y * (2*max_z/3 - max_z/3);
	int max_x += 1;
	int max_y += 1;
	int max_z += 1;

	FILE *file = fopen(argv[1], "w");

	fprintf(file, "%d %d %d %d %d %d\n", max_x, max_y, max_z, dim, n, total);
	
	for(i = min; i < max_x; i++) {
		for(j = min; j < max_y; j++) {
			fprintf(file, "%d %d %d\n", i, j, min);
		}
	}

	for(i = min; i < max_x; i++) {
		for(j = min; j < max_y; j++) {
			fprintf(file, "%d %d %d\n", i, j, max_z - 1);
		}
	}

	for(i = min; i < max_x; i++) {
		for(k = min; k < max_z; k++) {
			fprintf(file, "%d %d %d\n", i, min, k);
		}
	}

	for(i = min; i < max_x; i++) {
		for(k = min; k < max_z; k++) {
			fprintf(file, "%d %d %d\n", i, max_y - 1, k);
		}
	}

	for(j = min; j < max_y; j++) {
		for(k = max_z/3; k < 2*max_z/3; k++) {
			fprintf(file, "%d %d %d\n", max_x/3, j, k);
		}
	}
}
