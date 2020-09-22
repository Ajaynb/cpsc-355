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

int
randomNumber(int m, int n)
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
        for(int r = 0; r < table->column; r++){
            table->array[t][r] = randomNumber(0, 9);
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

int main()
{

    time_t t;
    srand((unsigned)time(&t));

    printf("Say number \n");

    int row = 0;
    int column = 0;
    char file[40];
    scanf("%d %d %s", &row, &column, &file);

    printf("number = %d %d %s\n", row, column, file);

    struct Table table;
    table.row = row;
    table.column = column;

    initialize(&table);
    display(&table);

    free(&table);
}
