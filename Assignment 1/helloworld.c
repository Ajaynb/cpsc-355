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
    int **sorted;
    int row;
    int column;
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
    table->sorted = (int **)calloc(table->row, sizeof(int));
    for (int t = 0; t < table->row; t++)
    {
        table->array[t] = (int *)calloc(table->column, sizeof(int));
        table->sorted[t] = (int *)calloc(table->column, sizeof(int));
        for (int r = 0; r < table->column; r++)
        {
            int rand = randomNumber(0, 9);
            table->array[t][r] = table->sorted[t][r] = rand;
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

void displaySorted(struct Table *table)
{
    for (int t = 0; t < table->row; t++)
    {
        for (int r = 0; r < table->column; r++)
        {
            printf("%d ", table->sorted[t][r]);
        }
        printf("\n");
    }
}

void bubbleSort(struct Table *table)
{
    for (int t = 0; t < table->row; t++)
    {
        for (int r = 0; r < table->column; r++)
        {
            for (int r = 0; r < table->column - 1; r++)
            {
                if (table->sorted[t][r] > table->sorted[t][r + 1])
                {
                    int temp = table->sorted[t][r];
                    table->sorted[t][r] = table->sorted[t][r + 1];
                    table->sorted[t][r + 1] = temp;
                }
            }
        }
    }
}

int main()
{

    time_t t;
    srand((unsigned)time(&t));

    // printf("Say number \n");

    int row, column;
    // char file[40];
    // scanf("%d %d %s", &row, &column, &file);
    row = 6, column = 4;

    // printf("number = %d %d %s\n", row, column, file);

    struct Table table;
    table.row = row;
    table.column = column;

    initialize(&table);
    display(&table);

    // int index, top;
    // printf("Enter the index of the word you are searching for: ");
    // scanf("%d", &index);

    // printf("How many top documents you want to retrieve? ");
    // scanf("%d", &top);

    printf("\n");

    int arr[] = {0, 2, 6, 2, 5};
    bubbleSort(&table);
    // printf("%d %d %d %d %d", arr2[0], arr2[1], arr2[2], arr2[3], arr2[4]);
    displaySorted(&table);

    free(&table);
}
