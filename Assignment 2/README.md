# Assignment 2

## Input Validation

Similar to the last assignment: 
> There are validation checks in the code to identify invalid inputs, but instead of throwing error and ask again, it would **tolerant** the user's error at maximum, by having a fallback.

Here are the possible cases and their fallbacks.
 1. If the user input for word number is less than `5`, then the word number will set to the minimum default value `5`, and generate 5 words with their occurence. Same principle for `20` words.
 2. If the user input for word number is not a number, the word number would then be `20`.

