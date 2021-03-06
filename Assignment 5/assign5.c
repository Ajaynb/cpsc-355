#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <time.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>
#include <limits.h>

// Determine which one is greater/smaller between the given two numbers
#define max(x, y) (x > y) ? x : y
#define min(x, y) (x < y) ? x : y

// Constants, avoiding magic numbers
#define MAX_ROW 20
#define MAX_COL 20
#define MIN_ROW 5
#define MIN_COL 5


struct Table {
    int array[MAX_ROW][MAX_COL];
    int row;
    int column;
};

struct WordFrequency {
    double frequency;
    int word;
    int times;
    int document;
};

// Generate random number between the given range, inclusive.
int randomNum(int m, int n) {
    // If the upper bound and the lower bound are the same
    if (m == n) {
        return m;
    }

    // For protection, check again the lower and upper bound
    int upper = max(m, n);
    int lower = min(m, n);

    return rand() % (upper - lower + 1) + lower;
}

// Initializing and populating the table
void initialize(struct Table* table, char* file) {
    bool fromFile = (file != NULL); // Whether populate table from file
    FILE* fp;
    char text[UCHAR_MAX];

    // Open the file
    if (fromFile) {
        fp = fopen(file, "r");
    }

    // If file fails to open, the file will be ignore
    if(fp == NULL){
        fromFile = false;
    }

    // Populate table with default value 0
    for (int k = 0; k < 20; k++) {
        for (int j = 0; j < 20; j++) {
            table->array[k][j] = 0;
        }
    }

    // Populate table with actual values
    for (int t = 0; t < table->row; t++) {
        // Read next line of the file
        if (fromFile && fgets(text, sizeof(text), fp) == NULL) {
            break;
        }

        for (int r = 0; r < table->column; r++) {
            if (fromFile) {
                int num = text[r * 2]; // Next character

                if (num >= 48 && num <= 57) {
                    table->array[t][r] = (num - 48);
                } else {
                    break;
                }
            } else {
                int rand = randomNum(0, 9);
                table->array[t][r] = rand;
            }
        }
    }

    if (fromFile) {
        fclose(fp);
    }

}

// Display the table in console
void display(struct Table* table) {
    printf("===== Table =====\n");
    for (int t = 0; t < table->row; t++) {
        for (int r = 0; r < table->column; r++) {
            printf(" %d ", table->array[t][r]);
        }
        printf("\n");
    }
}

// Show top relevant documents
void topRelevantDocs(struct Table* table, int index, int top) {

    // Preventing invalid user input. Index cannot be greater than the table size or smaller than 0.
    // If smaller than 0, set to 0. If greater than table size, set to table size.
    index = min(index, table->column - 1);
    index = max(0, index);
    top = min(top, table->row);
    top = max(0, top);

    // Build WordFrequency array
    struct WordFrequency words[MAX_ROW];
    for (int t = 0; t < table->row; t++) {
        int documentSize = 0; // Total words of current document
        for (int r = 0; r < table->column; r++) {
            documentSize += table->array[t][r];
        }

        struct WordFrequency wf;
        wf.document = t;
        wf.word = index;
        wf.times = table->array[t][index];
        wf.frequency = (documentSize > 0) ? 1.0 * wf.times / documentSize : 0.0; // Preventing from dividing by 0
        words[t] = wf;
    }

    // Bubble Sort
    for (int t = 0; t < table->row; t++) {
        for (int r = 0; r < table->row - 1; r++) {
            if (words[r].frequency < words[r + 1].frequency) { // The greater ones should be at the top
                // Swap two WordFrequency
                struct WordFrequency wf = words[r];
                words[r] = words[r + 1];
                words[r + 1] = wf;
            }
        }
    }

    // Print out the result
    printf("The top documents are: \n");
    for (int t = 0; t < top; t++)
    {
        // printf("Word %02d in ", words[t].word); // Uncomment if neccessary
        printf("Document %02d: ", words[t].document);
        printf("Occurence of %d and ", words[t].times);
        printf("Frequency of %.1f%% ", words[t].frequency);
        printf("\n");
    }

}


int main(int argc, char* argv[]) {

    time_t timestamp;
    srand((unsigned)time(&timestamp));

    int row, column;
    if (argc >= 3) { // If row and column are given in the command line
        row = atoi(argv[1]), column = atoi(argv[2]);
        row = min(max(MIN_ROW, row), MAX_ROW), column = min(max(MIN_COL, column), MAX_COL);
    } else { // Otherwise, set to the minimum
        row = column = MIN_ROW;
    }

    // Initializing table
    struct Table table;
    table.row = row;
    table.column = column;

    // Populate and display
    initialize(&table, (argc >= 4) ? argv[3] : NULL); // If file is given, otherwise NULL
    display(&table);

    printf("\n");

    // User command
    char command;
    do {

        int index, top;

        printf("What is the index of the word you are searching for? ");
        scanf(" %d", &index);

        printf("How many top documents you want to retrieve? ");
        scanf(" %d", &top);

        printf("\n");


        // Search top documents
        topRelevantDocs(&table, index, top);
        printf("\n");

        // Ask for another search
        printf("Do you want to search again? (y/n) ");
        scanf(" %c", &command);

        printf("\n");

    } while (command == 'y');


    printf("Ended.\n");


    return 0;
}
