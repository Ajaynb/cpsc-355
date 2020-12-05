# Assignment 5

## Macros

There are macros are referenced in file `macro.m4`, from: http://lynchjim.com/doc/m4/examples/
 - quote
 - foreach2
 - forloop3

Other macros are implemented based on these.

## Error detection
Like previous assignments, all the invalid input will be reset to a default value and generate proper table.
If value is less than the minimum 5, the size will be reset to 5. Same for 20, and same for searching top documents when providing index and amount.
If the input is not number, size will be one of them.