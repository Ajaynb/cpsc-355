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
#define clear_screen() printf("\ec");
#define style(color, bold) printf("\033[%d;%dm", bold, color);

#define MIN_ROW 10
#define MIN_COL 10

#define NEG_PERCENT 0.4
#define SPE_PERCENT 0.2

#define EXIT '*'
#define REWARD '$'

#define GAMING 0
#define WIN 1
#define DIE 2
#define QUIT 3

#define RED 31
#define GREEN 32
#define YELLOW 33
#define BLUE 34
#define CYAN 36
#define CLEAR 0

struct Board {
    struct Tile* array;
    unsigned int row;
    unsigned int column;
    unsigned int tiles;
    unsigned int negatives;
    unsigned int specials;
    int lives;
    float score;
    int bombs;
    int range;
    int status;
    unsigned long time;
    unsigned int final_score;
    char player[100];
};

struct Tile {
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
    board->tiles = board->row * board->column;
    board->array = calloc(sizeof(struct Tile), board->tiles);

    // Initialize statistics
    board->negatives = 0;
    board->specials = 0;
    board->lives = 3;
    board->score = 0.0;
    board->bombs = board->tiles * 0.05;
    board->range = 1;
    board->status = GAMING;

    // Generate map
    for (int t = 0; t < board->tiles; t++) {
        int type = randomNum(0, 9);
        float value = randomNum(0, 15) + randomNum(0, 99) * 0.01;
        value = min(15, value);
        value = max(0.01, value);

        struct Tile bl;
        bl.value = value;
        bl.covered = true;

        board->array[t] = bl;
    }

    // Flip to negative numbers
    while (board->negatives < (int)(board->tiles * NEG_PERCENT)) {
        int index = randomNum(0, board->tiles - 1);
        if (board->array[index].value >= 0) {
            board->array[index].value *= -1;
            board->negatives++;
        }
    }

    // Flip to specials
    while (board->specials < (int)(board->tiles * SPE_PERCENT)) {
        int index = randomNum(0, board->tiles - 1);
        board->array[index].value = REWARD;
        board->specials++;
    }

    // Generate Exit
    int exitIndex = randomNum(0, board->tiles - 1);
    board->array[exitIndex].value = EXIT;
}

void displayGame(struct Board* board, bool peek) {
    static float score;

    for (int t = 0; t < board->tiles; t++) {
        int col = t % board->column;
        float value = board->array[t].value;

        if (!board->array[t].covered || peek) {
            switch ((int)value) {
            case REWARD:
            case EXIT:
                if (value == EXIT) style(CYAN, !peek) else style(YELLOW, !peek);

                if (peek) printf("   %c    ", (int)value);
                else printf("%c  ", (int)value);

                style(CLEAR, false);
                break;
            default:
                if (value > 0) style(GREEN, !peek) else style(RED, !peek);

                if (peek == true) printf("%6.2f  ", value);
                else printf("%c  ", (value > 0) ? '+' : '-');

                style(CLEAR, false);
                break;
            }
        } else {
            printf("·  ");
        }

        if (col == board->column - 1) {
            printf("\n");
        }
    }

    if (peek) {
        float negRate = (1.0 * board->negatives / board->tiles) * 100;
        printf("Total negatives: %d/%d (%.2f%%)\n", board->negatives, board->tiles, negRate);

        float speRate = (1.0 * board->specials / board->tiles) * 100;
        printf("Total specials:  %d/%d (%.2f%%)\n", board->specials, board->tiles, speRate);
    } else {
        printf("Lives: %d\n", board->lives);
        printf("Score: %.2f	", board->score);

        float scoreChange = board->score - score;
        if (scoreChange > 0) style(GREEN, false) else style(RED, false);
        if (scoreChange != 0) printf("(%+.2f)", scoreChange);
        style(CLEAR, false);
        printf("\n");

        printf("Bombs: %d	", board->bombs);
        if (board->range > 1) {
            style(CYAN, false);
            printf("(Reward: %dx range)", board->range);
            style(CLEAR, false)
        }
        printf("\n");
    }

    score = board->score;

}

int calculateScore(struct Board* board) {
    int score = board->score * 1000 - board->time * 500 + board->bombs * 250 + board->lives * 1000;
    return score;
}

void playGame(struct Board* board, const int x, const int y) {
    static unsigned long start_time;
    static unsigned long end_time;

    if (start_time == 0) {
        start_time = time(NULL);
    }

    if (x < 0 || x >= board->row ||
        y < 0 || y >= board->column) {
        return;
    }

    int range = board->range;
    board->range = 1;
    board->bombs--;

    for (int t = range * -1; t <= range; t++) {
        for (int r = range * -1; r <= range; r++) {
            int new_x = x + t;
            int new_y = y + r;
            int index = (new_x * board->column) + new_y;

            if (index >= 0 && index < board->tiles &&
                new_y >= 0 && new_y < board->column &&
                board->array[index].covered) {
                board->array[index].covered = false;
                float value = board->array[index].value;

                switch ((int)value) {
                case REWARD:
                    board->range++;
                    break;
                case EXIT:
                    board->status = WIN;
                    end_time = time(NULL);
                    board->time = end_time - start_time;
                    board->final_score = calculateScore(board);
                    break;
                default:
                    board->score += value;
                    break;
                }
            }
        }
    }

    if (board->bombs <= 0) {
        board->status = DIE;
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

void logScore(struct Board* board) {
    FILE* fptr;
    fptr = fopen("scores.log", "a");
    fprintf(fptr, "%s %d %lu %.2f %d %d %d %d\n", board->player, board->final_score, board->time, board->score, board->bombs, board->lives, board->tiles, board->status);
    fclose(fptr);
}

void displayTopScores(int n) {
    FILE* fptr;
    struct Board board;
    fptr = fopen("scores.log", "r");
    while (fscanf(fptr, "%s %d %lu %f %d %d %d %d\n", board.player, &board.final_score, &board.time, &board.score, &board.bombs, &board.lives, &board.tiles, &board.status) != EOF) {
        // printf("final score: %s\n", board.player);
        // printf("final score: %d\n", board.final_score);
        // printf("final score: %lu\n", board.time);
        // printf("final score: %.2f\n", board.score);
        // printf("final score: %d\n", board.bombs);
        // printf("final score: %d\n", board.lives);
        // printf("final score: %d\n", board.tiles);
        // printf("final score: %d\n", board.status);
        printf("%s %d %lu %.2f %d %d %d %d\n", board.player, board.final_score, board.time, board.score, board.bombs, board.lives, board.tiles, board.status);
    }
    fclose(fptr);
}

int main(int argc, char* argv[]) {

    time_t timestamp;
    srand((unsigned)time(&timestamp));

    clear_screen();

    // displayTopScores(1);
    // return 0;

    struct Board board;
    board.row = 15;
    board.column = 15;

    printf("Board: \n");

    initializeGame(&board);
    displayGame(&board, true);

    printf("\nPress ENTER key to start game...");
    getchar();

    char input[10];
    int x = -10, y = -10;

    do {
        clear_screen();
        displayGame(&board, false);

        printf("\n");
        printf("Enter q to quit, \n");
        printf("Enter bomb position (x y): ");
        gets(input);

        if (extractInput(input, "%d %d", &x, &y) == 2) {
            playGame(&board, x, y);
        } else if (input[0] == 'q') {
            board.status = QUIT;
        }

        printf("\n");
    } while (board.status == GAMING);


    if (board.status != QUIT) {
        clear_screen();
        displayGame(&board, false);
        printf("\n");

        if (board.status == DIE) {
            printf("You die.\n");
        } else if (board.status == WIN) {
            printf("You win!\n");
        }

        printf("press ENTER to continue ... ");
        getchar();
        printf("\n");

        clear_screen();
        printf("Please enter your name (no space): ");
        scanf("%s", board.player);
        logScore(&board);

        clear_screen();

        printf("Your game time is: %lus\n", board.time);
        printf("Your score is: %d pts\n", board.final_score);

    }


}
