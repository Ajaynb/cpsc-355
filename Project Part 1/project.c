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
    struct Block* array;
    int row;
    int column;
    int size;
    int score;
    unsigned int negAmount;
    unsigned int speAmount;
};

struct Block {
    float value;
    bool covered;
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
    board->size = board->row * board->column;
    board->array = calloc(sizeof(struct Block), board->size);

    // Initialize statistics
    board->negAmount = 0;
    board->speAmount = 0;

    // Generate map
    for (int t = 0; t < board->size; t++) {
        int type = randomNum(0, 9);
        float value = randomNum(0, 15) + randomNum(0, 99) * 0.01;
        value = min(15, value);
        value = max(0.01, value);

        struct Block bl;
        bl.value = value;
        bl.covered = true;

        board->array[t] = bl;
    }
    
    // Flip to negative numbers
    while (board->negAmount < (int)(board->size * NEG_PERCENT)) {
        int index = randomNum(0, board->size - 1);
        if (board->array[index].value >= 0) {
            board->array[index].value *= -1;
            board->negAmount++;
        }
    }

    // Flip to specials
    while (board->speAmount < (int)(board->size * SPE_PERCENT)) {
        int index = randomNum(0, board->size - 1);
        board->array[index].value = REWARD;
        board->speAmount++;
    }

    // Generate Exit
    int exitIndex = randomNum(0, board->size - 1);
    board->array[exitIndex].value = EXIT;
}

void displayBoard(struct Board* board, bool peek) {
    for (int t = 0; t < board->size; t++) {
        int col = t % board->column;
        int value = board->array[t].value;
        
        if (!board->array[t].covered || peek) {
            switch (value) {
            case REWARD:
            case EXIT:
                if (peek) printf("   %c    ", value);
                else printf(" %c ", value);
                break;
            default:
                if (peek) printf("%6.2f  ", board->array[t].value);
                else printf(" %c ", (board->array[t].value > 0) ? '+' : '-');
                break;
            }
        } else {
            printf(" X ");
        }
        

        if (col == board->column - 1) {
            printf("\n");
        }
    }

    printf("negAmount %d, ", board->negAmount);
    printf("size %d\n", board->size);
    float negRate = (1.0 * board->negAmount / board->size) * 100;
    printf("Total negative number rate: %.2f%%\n", negRate);

    printf("speAmount %d, ", board->speAmount);
    printf("size %d\n", board->size);
    float speRate = (1.0 * board->speAmount / board->size) * 100;
    printf("Total specials rate: %.2f%%\n", speRate);
}


int main(int argc, char* argv[]) {

    time_t timestamp;
    srand((unsigned)time(&timestamp));

    struct Board board;
    board.row = 27;
    board.column = 13;

    initializeGame(&board);
    displayBoard(&board, true);

    displayBoard(&board, false);



}
