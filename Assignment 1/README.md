# Assignment #1

## Sorting algorithm
The sorting algorithm used is **Bubble Sort**, which can be found in function `topRelevantDocs`.

## Input validation
There are validation checks in the code to identify invalid ibputs, but instead of throwing error and ask again, it would **tolerant** the user's error at maximum, by having a fallback.

Here are the possible cases and their fallbacks.

1. If the file determined in the command line argument fails to open (for example, file does not exist), the file will be ignored. And as usual it will generate a random table.
2. If user does not determine the table size at all in the command line, a default/minimum size of 5x5 random table will be generated.
3. If the index of searching word is a negative number, the index will be set to 0. If the index exceeds the table size, the index will be set to the largest index.
4. If the number of top document is a negative number, the number will be set to 0. If the number exceeds the total number of documents, the number will be set to the total number.
5. If user determine a table size smaller than 5x5 in the command line, the table size will be set to the minimum size 5x5. If greater, it will be set to maximum size 20x20.
6. If user input any character other than 'y' or 'n' for question of searching again, it will stop searching.

## Print and Scan functions

For having a good readability and elegent implementation of the code, in order to print and scan to console and log file at the same time, a customized `print` and `scan` functions are implemented.

There is no implementation for such functions, so by researching online by pieces for a long time, they are implemented from the help of the following references:

- https://stackoverflow.com/questions/6420194/how-to-print-both-to-stdout-and-file-in-c
- https://en.cppreference.com/w/c/variadic
- https://en.cppreference.com/w/c/io/vfprintf
- https://en.cppreference.com/w/c/io/vfscanf
- https://linux.die.net/man/3/va_arg

As a result, the `print` function has the same functionality and usage with `printf`, `scan` has the same with `scanf`. In order to migrate to the customized functions, just simply replace all occurences of `printf` and `scanf` in the code with `print` and `scan`.