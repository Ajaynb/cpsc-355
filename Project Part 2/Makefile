all: 
	m4 project.asm > project.s
	m4 randomNum.asm > randomNum.s
	gcc project.s randomNum.s -o project.out

#Remove all object files and the executable files as well	
clean: 
	rm *.o
