# Assignment 5

## Macros

There are macros are referenced in file `macro.m4`, from: http://lynchjim.com/doc/m4/examples/
 - quote
 - foreach2
 - forloop3

Other macros are implemented based on these.

## Error detection
Like previous assignments, all the invalid input will be reset to a default value and generate proper table.

For row and column from command line argument:
- If value is less than the minimum 5, the size will be reset to 5. Same for 20.

For searching top documents:
- When providing index, if the index is less than 0, it will be 0; if it is greater than the row amount, then it will be the maximum number of words.
- When providing amount of top docs, if the amount if less than 0, then it will be reset to 0 which is printing nothing; or it will be the maximum number of documents which is printing all documents.

For input file from command line argument:
- If does exist, then read from the file to populate the table array
- If not exist, it will ignore the file and populate the table array with random numbers, just like how it runs without providing a file.

## File logging

If you see nowhere the function `logToFile` is invoked, it is from macro.
In macro `xprint` and `xscan` invoke this function. So, whenever there is a print or scan, it logges to the file.