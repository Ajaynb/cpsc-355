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

#define MIN_ROW 10
#define MIN_COL 10
#define NEG_PERCENT 0.4
#define SPE_PERCENT 0.2
#define EXIT '*'
#define REWARD '$'

struct Board {
    float* array;
    int row;
    int column;
    int score;
    unsigned int negAmount;
    unsigned int speAmount;
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
    int range = upper - lower;

    // Get the smallest 2^x larger than range
    int modular = 1;
    while (range > modular)
        modular <<= 1;

    // Generate random number
    int remainder = -1;
    while (!(lower <= remainder && remainder <= upper)) {
        remainder = (rand() & (modular - 1)) + lower;
    }

    return remainder;
}

void initializeGame(struct Board* board) {
    // Ensure the board is at least the minimum size
    board->row = max(MIN_ROW, board->row);
    board->column = max(MIN_COL, board->column);

    // Intialize map by allocating memory
    int boardSize = board->row * board->column;
    board->array = calloc(sizeof(float), boardSize);

    // Initialize statistics
    board->negAmount = 0;
    board->speAmount = 0;

    // Generate map
    for (int t = 0; t < boardSize; t++) {
        int type = randomNum(0, 9);
        float value = randomNum(0, 15) + randomNum(0, 99) * 0.01;
        value = min(15, value);
        value = max(0.01, value);

        board->array[t] = value;
    }
    
    while (board->negAmount != (int)(boardSize * NEG_PERCENT)) {
        int index = randomNum(0, boardSize - 1);
        if (board->array[index] >= 0) {
            board->array[index] *= -1;
            board->negAmount++;
        }
    }

    while (board->speAmount != (int)(boardSize * SPE_PERCENT)) {
        int index = randomNum(0, boardSize - 1);
        board->array[index] = REWARD;
        board->speAmount++;
    }

    // Generate Exit
    int exitIndex = randomNum(0, boardSize - 1);
    board->array[exitIndex] = EXIT;
}

void displayBoard(struct Board* board) {
    int boardSize = board->row * board->column;
    for (int t = 0; t < boardSize; t++) {
        int col = t % board->column;
        int value = board->array[t];

        switch (value) {
        case REWARD:
        case EXIT:
            printf("   %c    ", value);
            break;
        default:
            printf("%6.2f  ", board->array[t]);
            break;
        }


        if (col == board->column - 1) {
            printf("\n");
        }
    }

    printf("negAmount %d, ", board->negAmount);
    printf("size %d\n", boardSize);
    float negRate = (1.0 * board->negAmount / boardSize) * 100;
    printf("Total negative number rate: %.2f%%\n", negRate);

    printf("speAmount %d, ", board->speAmount);
    printf("size %d\n", boardSize);
    float speRate = (1.0 * board->speAmount / boardSize) * 100;
    printf("Total special number rate: %.2f%%\n", speRate);
}


int main(int argc, char* argv[]) {

    time_t timestamp;
    srand((unsigned)time(&timestamp));

    struct Board board;
    board.row = 27;
    board.column = 13;

    initializeGame(&board);
    displayBoard(&board);


}
