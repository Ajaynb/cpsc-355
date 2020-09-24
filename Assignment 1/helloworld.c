#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>

#define max(x, y) (x > y) ? x : y
#define min(x, y) (x < y) ? x : y

struct Table
{
    int **array;
    int row;
    int column;
};

struct WordFrequency
{
    double frequency;
    int word;
    int times;
    int document;
};

int randomNum(int m, int n)
{
    // If the upper bound and the lower bound are the same
    if (m == n)
    {
        return m;
    }

    // For protection, check again the lower and upper bound
    int upper = max(m, n);
    int lower = min(m, n);

    return rand() % (upper - lower) + lower;
}

void initialize(struct Table *table)
{
    table->array = (int **)calloc(table->row, sizeof(int));
    for (int t = 0; t < table->row; t++)
    {
        table->array[t] = (int *)calloc(table->column, sizeof(int));
    }
}

void populate(struct Table *table, char *file)
{
    for (int t = 0; t < table->row; t++)
    {
        for (int r = 0; r < table->column; r++)
        {
            int rand = randomNum(0, 9);
            table->array[t][r] = rand;
        }
    }
}

void display(struct Table *table)
{
    printf("===== Table ===== \n");
    for (int t = 0; t < table->row; t++)
    {
        for (int r = 0; r < table->column; r++)
        {
            printf(" %d ", table->array[t][r]);
        }
        printf("\n");
    }
}

struct WordFrequency *topRelevantDocs(struct Table *table, int index)
{
    struct WordFrequency word;

    struct WordFrequency *words = (struct WordFrequency *)calloc(table->row, sizeof(word));
    for (int t = 0; t < table->row; t++)
    {
        int documentSize = 0;
        for (int r = 0; r < table->column; r++)
        {
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
    for (int t = 0; t < table->row; t++)
    {
        for (int r = 0; r < table->row - 1; r++)
        {
            if (words[r].frequency < words[r + 1].frequency)
            {
                struct WordFrequency wf = words[r];
                words[r] = words[r + 1];
                words[r + 1] = wf;
            }
        }
    }

    return words;
}

void destroy(struct Table *table)
{
    for (int t = 0; t < table->row; t++)
    {
        // free(*table->array[t]);
    }
    free(*table->array);
    // free(*table->documentsSize);
    free(table);
}

void logToFile()
{
    freopen("assign1.log", "wt", stdout);
}

int main(int argc, char *argv[])
{

    time_t timestamp;
    srand((unsigned)time(&timestamp));

    // logToFile();

    // TODO: Read from file

    int row, column;
    char *file;

    if (argc > 1)
    {
        row = atoi(argv[1]), column = atoi(argv[2]);
    }
    else
    {
        row = 5, column = 6;
    }

    if (argc > 3)
    {
        // strncpy(file, argv[3], 40);
        file = argv[3];
    }

    printf("Args: %d %d %s\n", row, column, file);

    struct Table table;
    table.row = row;
    table.column = column;

    initialize(&table);
    populate(&table, file);
    display(&table);

    printf("\n");

    char command = 'y';

    do
    {
        int index, top;

        printf("What is the index of the word you are searching for? ");
        scanf(" %d", &index);

        printf("How many top documents you want to retrieve? ");
        scanf(" %d", &top);

        printf("\n");

        // Preventing invalid user input. Index cannot be greater than the table size.
        index = min(index, table.column - 1);
        index = max(0, index);

        // Top words
        struct WordFrequency *topWords = (struct WordFrequency *)topRelevantDocs(&table, index);

        int size = 0;
        size = min(top, table.row);
        size = max(0, size);

        printf("The top documents are: \n");
        for (int t = 0; t < size; t++)
        {
            // printf("Word %d in ", topWords[t].word);
            printf("Document %d: ", topWords[t].document);
            printf("Times of %d and ", topWords[t].times);
            printf("Frequency of %.1f%% ", topWords[t].frequency * 100);
            printf("\n");
        }

        free(topWords);

        printf("\n");

        printf("Do you want to search again? (y/n) ");
        scanf(" %c", &command);

        printf("\n");

    } while (command != 'n');

    destroy(&table);
}
