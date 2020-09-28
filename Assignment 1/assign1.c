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

// Log file stream
FILE* fp_log;

struct Table {
    int array[20][20];
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



void logToFile() {
    fp_log = fopen("assign1.log", "w");
}

void logOffFile() {
    fclose(fp_log);
}

void print(const char* restrict format, ...) {
    va_list vlist;

    va_start(vlist, format);
    vprintf(format, vlist);
    va_end(vlist);

    va_start(vlist, format);
    vfprintf(fp_log, format, vlist);
    va_end(vlist);
}

void scan(const char* restrict format, ...) {
    va_list vlist;

    va_start(vlist, format);
    vscanf(format, vlist);
    va_end(vlist);


    va_start(vlist, format);
    while (*format != '\0') {
        if (*format == 'd') {
            int* i = va_arg(vlist, int*);
            fprintf(fp_log, "%d", *i);
        } else if (*format == 'c') {
            int* c = va_arg(vlist, int*);
            fprintf(fp_log, "%c", *c);
        } else if (*format == 's') {
            char* s = va_arg(vlist, char*);
            fprintf(fp_log, "%s", s);
        }
        ++format;
    }
    fprintf(fp_log, "%s", "\n");
    va_end(vlist);
}


void initialize(struct Table* table, char* file) {
    bool fromFile = (file != NULL);
    FILE* fp;
    char text[UCHAR_MAX];

    if (fromFile) {
        fp = fopen(file, "r");
    }

    for (int k = 0; k < 20; k++) {
        for (int j = 0; j < 20; j++) {
            table->array[k][j] = 0;
        }
    }

    for (int t = 0; t < table->row; t++) {
        if (fromFile && fgets(text, sizeof(text), fp) == NULL) {
            break;
        }

        for (int r = 0; r < table->column; r++) {
            if (fromFile) {
                int num = text[r * 2];

                if (num >= 48 && num <= 57) {
                    table->array[t][r] = num - 48;
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

void display(struct Table* table) {
    print("===== Table =====\n");
    for (int t = 0; t < table->row; t++) {
        for (int r = 0; r < table->column; r++) {
            print(" %d ", table->array[t][r]);
        }
        print("\n");
    }
}

void topRelevantDocs(struct Table* table, int index, int top) {

    // Preventing invalid user input. Index cannot be greater than the table size.
    index = min(index, table->column - 1);
    index = max(0, index);
    top = min(top, table->row);
    top = max(0, top);

    struct WordFrequency words[20];
    for (int t = 0; t < table->row; t++) {
        int documentSize = 0;
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
            if (words[r].frequency < words[r + 1].frequency) {
                struct WordFrequency wf = words[r];
                words[r] = words[r + 1];
                words[r + 1] = wf;
            }
        }
    }


    print("The top documents are: \n");
    for (int t = 0; t < top; t++)
    {
        // print("Word %02d in ", words[t].word);
        print("Document %02d: ", words[t].document);
        print("Occurence of %d and ", words[t].times);
        print("Frequency of %.1f%% ", words[t].frequency * 100);
        print("\n");
    }

}

int main(int argc, char* argv[]) {

    time_t timestamp;
    srand((unsigned)time(&timestamp));

    int row, column;

    if (argc >= 3) {
        row = atoi(argv[1]), column = atoi(argv[2]);
        row = min(max(5, row), 20), column = min(max(5, column), 20);
    } else {
        row = column = 5;
    }

    struct Table table;
    table.row = row;
    table.column = column;

    logToFile();

    initialize(&table, (argc >= 4) ? argv[3] : NULL);
    display(&table);


    print("\n");

    char command;

    do {

        int index, top;

        print("What is the index of the word you are searching for? ");
        scan(" %d", &index);

        print("How many top documents you want to retrieve? ");
        scan(" %d", &top);

        print("\n");

        topRelevantDocs(&table, index, top);

        print("\n");

        print("Do you want to search again? (y/n) ");
        scan(" %c", &command);

        print("\n");

    } while (command == 'y');


    print("Ended.\n");

    logOffFile();

    return 0;
}
