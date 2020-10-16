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
#define clear_screen() printf("\033[2J");

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
    unsigned int negatives;
    unsigned int specials;
    int lives;
    float score;
    int bombs;
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
    // board->row = max(MIN_ROW, board->row);
    // board->column = max(MIN_COL, board->column);

    // Intialize map by allocating memory
    board->size = board->row * board->column;
    board->array = calloc(sizeof(struct Block), board->size);

    // Initialize statistics
    board->negatives = 0;
    board->specials = 0;
    board->lives = 3;
    board->score = 0.0;
    board->bombs = 3;

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
    while (board->negatives < (int)(board->size * NEG_PERCENT)) {
        int index = randomNum(0, board->size - 1);
        if (board->array[index].value >= 0) {
            board->array[index].value *= -1;
            board->negatives++;
        }
    }

    // Flip to specials
    while (board->specials < (int)(board->size * SPE_PERCENT)) {
        int index = randomNum(0, board->size - 1);
        board->array[index].value = REWARD;
        board->specials++;
    }

    // Generate Exit
    int exitIndex = randomNum(0, board->size - 1);
    board->array[exitIndex].value = EXIT;
}

void displayGame(struct Board* board, bool peek) {
    for (int t = 0; t < board->size; t++) {
        int col = t % board->column;
        int value = board->array[t].value;
        
        if (!board->array[t].covered || peek) {
            switch (value) {
            case REWARD:
            case EXIT:
                if (peek) printf("   %c    ", value);
                else if (value == EXIT) printf("\033[1;34m%c\033[0;m  ", value);
                else printf("\033[1;36m%c\033[0;m  ", value);
                break;
            default:
                if (peek) printf("%6.2f  ", board->array[t].value);
                else printf("%s  ", (board->array[t].value > 0) ? "\033[1;32m+\033[0m" : "\033[1;31m-\033[0m");
                break;
            }
        } else {
            printf("x  ");
        }

        if (col == board->column - 1) {
            printf("\n");
        }
    }

    if (peek) {
        float negRate = (1.0 * board->negatives / board->size) * 100;
        printf("Total negatives: %d/%d (%.2f%%)\n", board->negatives, board->size, negRate);

        float speRate = (1.0 * board->specials / board->size) * 100;
        printf("Total specials:  %d/%d (%.2f%%)\n", board->specials, board->size, speRate);
    } else {
        printf("Lives: %d\nScore: %.2f\nBombs: %d\n", board->lives, board->score, board->bombs);
    }

}

void playGame(struct Board* board, const int x, const int y) {
    for (int t = -1; t <= 1; t++) {
        for (int r = -1; r <= 1; r++) {
            int index = ((x + t) * board->column) + y + r;
            int current_y = index % board->column;

            if (index >= 0 && index < board->size && current_y >= y - 1 && current_y <= y + 1) {
                board->array[index].covered = false;
            }
        }
    }
}


int extractInput(const char* buf, const char* fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    int rc = vsscanf(buf, fmt, ap);
    va_end(ap);
    return rc;
}

int main(int argc, char* argv[]) {

    time_t timestamp;
    srand((unsigned)time(&timestamp));

    clear_screen();

    struct Board board;
    board.row = 5;
    board.column = 5;

    printf("Board: \n");
    
    initializeGame(&board);
    displayGame(&board, true);

    printf("\nPress ENTER key to start game...");
    getchar();

    char input[10];
    int x = -10, y = -10;

    while (input[0] != 'q') {
        clear_screen();

        if (extractInput(input, "%d %d", &x, &y) == 2) {
            playGame(&board, x, y);
        }

        displayGame(&board, false);

        printf("\n");
        printf("Enter q to quit, \n");
        printf("Enter bomb position (x y): ");
        gets(input);
        printf("\n");
    }

}
