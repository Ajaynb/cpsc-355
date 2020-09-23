#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <ctype.h>
#include <string.h>

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
    float frequency;
    int word;
    int times;
    int document;
};

int randomNumber(int m, int n)
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

void populate(struct Table *table)
{
    for (int t = 0; t < table->row; t++)
    {
        for (int r = 0; r < table->column; r++)
        {
            int rand = randomNumber(0, 9);
            table->array[t][r] = rand;
        }
    }
}

void display(struct Table *table)
{
    for (int t = 0; t < table->row; t++)
    {
        for (int r = 0; r < table->column; r++)
        {
            printf("%d ", table->array[t][r]);
        }
        printf("\n");
    }
}

struct WordFrequency *topRelevantDocs(struct Table *table, int index, int top)
{
    // Preventing invalid user input. Index cannot be greater than the table size.
    index = min(index, table->column);
    top = min(top, table->row);

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
        wf.frequency = (documentSize > 0) ? 1.0f * wf.times / documentSize : 0.0; // Preventing from dividing by 0
        words[t] = wf;
        printf("doc %d, word %d, times %d, freq %f\n", words[t].document, words[t].word, words[t].times, words[t].frequency);
    }

    // FIXME: Bubble Sort
    for (int t = 0; t < table->row; t++)
    {
        for (int r = 0; r < table->row - 1; r++)
        {
            struct WordFrequency wf = words[r];
            words[r] = words[r + 1];
            words[r + 1] = wf;
        }
    }

    printf("\n");

    for (int t = 0; t < table->row; t++)
    {
        printf("doc %d, word %d, times %d, freq %f\n", words[t].document, words[t].word, words[t].times, words[t].frequency);
    }

    struct WordFrequency *returnWords = (struct WordFrequency *)calloc(top, sizeof(word));
    for (int t = 0; t < top; t++)
    {
        returnWords[t] = words[table->row - t - 1];
    }

    free(words);

    return returnWords;
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

int main(int argc, char *argv[])
{

    time_t timestamp;
    srand((unsigned)time(&timestamp));

    // FIXME: log
    // freopen("log.txt", "wt", stdout);

    int row, column;
    char file[40];

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
        strncpy(file, argv[3], 40);
    }

    printf("Say number %d\n", argc);

    printf("number = %d %d %s\n", row, column, file);

    struct Table table;
    table.row = row;
    table.column = column;

    initialize(&table);
    populate(&table);
    display(&table);

    printf("\n");

    int index, top;
    printf("Enter the index of the word you are searching for: ");
    scanf("%d", &index);

    printf("How many top documents you want to retrieve? ");
    scanf("%d", &top);

    // FIXME: top words
    struct WordFrequency *topWords = (struct WordFrequency *)topRelevantDocs(&table, index, top);
    int size = min(top, table.row);
    for (int t = 0; t < size; t++)
    {
        printf("%d - %d, Document %d with Frequency %f\% of Word %d\n", t, size, topWords[t].document, topWords[t].frequency * 100, topWords[t].word);
    }

    destroy(&table);

    scanf("%d");
}
