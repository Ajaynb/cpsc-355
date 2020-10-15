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
int randomNum(int m, int n, bool neg) {
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

    // Turn random number into negative
    if (neg) remainder *= -1;

    return remainder;
}

void initializeGame(struct Board* board) {
    // Ensure the board is at least the minimum size
    board->row = max(MIN_ROW, board->row);
    board->column = max(MIN_COL, board->column);

    // Intialize map by allocating memory
    int boardSize = board->row * board->column;
    board->array = calloc(sizeof(float), boardSize);

    board->negAmount = 0;
    board->speAmount = 0;

    // Generate map
    for (int t = 0; t < boardSize; t++) {
        int type = randomNum(0, 9, false);
        float value;

        switch (type) {
        case 0:
        case 1:
        case 2:
        case 3:
            // Negative number
            value = randomNum(0, 15, true) + randomNum(0, 99, false) * 0.01;
            value = max(-15, value);
            value = min(-0.01, value);
            board->negAmount++;
            break;
        case 4:
        case 5:
            // Special
            if (type == 4 || type == 5) value = REWARD;
            board->speAmount++;
            break;
        case 6:
        case 7:
        case 8:
        case 9:
        default:
            // Positive number
            value = randomNum(0, 15, false) + randomNum(0, 99, false) * 0.01;
            value = min(15, value);
            value = max(0.01, value);
            break;
        }

        board->array[t] = value;

    }

    // Generate Exit
    int exitIndex = randomNum(0, boardSize - 1, false);
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
    board.row = 10;
    board.column = 10;

    initializeGame(&board);
    displayBoard(&board);


}
