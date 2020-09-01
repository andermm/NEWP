#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {

	//Checking arguments
	if (argc != 4) {
		fprintf(stderr, "Usage: %s [file_output] [size] [width]\n\n", argv[0]);
		exit(1);
	}
	
	int i;
	int n = 9;
	int min = 0;
	int max = atoi(argv[2]);
	int width = atoi(argv[3]);
	int bar_i = max/5;
	int bar_j = max/2 - max/10;
	int total = max + max + bar_j - bar_i;
	FILE *file = fopen(argv[1], "w");

	fprintf(file, "%d %d %d %d\n", max, width, n, total);
	
	for(i = min; i < max; i++) {
		fprintf(file, "%d %d\n", i + 1, min + 1);
	}
	for(i = min; i < width; i++) {
		fprintf(file, "%d %d\n", i + 1, max);
	}

	for(i = bar_i; i < bar_j; i++) {
		fprintf(file, "%d %d\n", bar_i, i);
	}
}
