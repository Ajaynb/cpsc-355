#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>


#define LOWER_LIMIT  0.5
#define UPPER_LIMIT  100.0
#define INCREMENT    0.5
#define FILENAME     "occurences.bin"


int main()
{
  int value;
  int fd;

  /*  Open a file for writing  */
  fd = openat(AT_FDCWD, FILENAME, O_WRONLY | O_CREAT, 0666);

  /*  Error check file creation  */
  if (fd < 0) {
    fprintf(stderr, "Can't open file for writing.  Aborting\n");
    exit(-1);
  }


	int i=0;
	while(i<401){	
	value=rand()%10;

	/*  Write out a random int to file  */
    int n_written = write(fd, (char *)&value, sizeof(int));

    /*  Error check the write  */
    if (n_written != sizeof(int)) {
      fprintf(stderr, "Error writing file.  Aborting.\n");
      close(fd);
      exit(-1);}
	i=i+1;
}


  /*  Close binary file  */
  close(fd);

  return 0;
}

  
