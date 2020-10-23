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
#define clear_screen() //printf("\ec");
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
};

struct Play {
    char player[100];
    int lives;
    float score;
    int bombs;
    int range;
    int status;
    unsigned long start_timestamp;
    unsigned long end_timestamp;
    unsigned long duration;
    unsigned int uncovered_tiles;
    int final_score;
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

void initializeGame(struct Board* board, struct Play* play) {
    // Ensure the board is at least the minimum size
    board->row = max(MIN_ROW, board->row);
    board->column = max(MIN_COL, board->column);

    // Intialize map by allocating memory
    board->tiles = board->row * board->column;
    board->array = calloc(sizeof(struct Tile), board->tiles);

    // Initialize statistics
    board->negatives = 0;
    board->specials = 0;
    play->lives = 3;
    play->score = 0.0;
    play->bombs = board->tiles * 0.05;
    play->range = 1;
    play->status = GAMING;
    play->uncovered_tiles = 0;

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

void displayGame(struct Board* board, struct Play* play, bool peek) {
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

                if (peek == true) printf("%+6.2f  ", value);
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

    printf("\n");

    if (peek) {
        float negRate = (1.0 * board->negatives / board->tiles) * 100;
        printf("Total negatives: %d/%d (%.2f%%)\n", board->negatives, board->tiles, negRate);

        float speRate = (1.0 * board->specials / board->tiles) * 100;
        printf("Total specials:  %d/%d (%.2f%%)\n", board->specials, board->tiles, speRate);
    } else {
        printf("Lives: %d\n", play->lives);
        printf("Score: %.2f	", play->score);

        float scoreChange = play->score - score;
        if (scoreChange > 0) style(GREEN, false) else style(RED, false);
        if (scoreChange != 0) printf("(%+.2f)", scoreChange);
        style(CLEAR, false);
        printf("\n");

        printf("Bombs: %d	", play->bombs);
        if (play->range > 1) {
            style(CYAN, false);
            printf("(Reward: %dx range)", play->range);
            style(CLEAR, false)
        }
        printf("\n");
    }

    score = play->score;

}

int calculateScore(struct Board* board, struct Play* play) {
    float rate = 1.0 * play->uncovered_tiles / board->tiles;
    float score = play->score * 20 + play->bombs * 33 + play->lives * 10;
    float time_deduct = play->duration * 46;
    int final_score = rate * score - time_deduct;
    play->final_score = final_score > 0 ? final_score : 0;
    return play->final_score;
}

void playGame(struct Board* board, struct Play* play, const int x, const int y) {
    if (x >= 0 && x < board->row && y >= 0 && y < board->column && play->status == GAMING) {
        int range = play->range;
        play->range = 1;
        play->bombs--;

        if (play->bombs <= 0) {
            play->bombs = 0;
            play->status = DIE;
        }

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
                    play->uncovered_tiles++;

                    switch ((int)value) {
                    case REWARD:
                        play->range++;
                        break;
                    case EXIT:
                        play->status = WIN;
                        break;
                    default:
                        play->score += value;
                        break;
                    }
                }
            }
        }
    }

    if (play->status != GAMING) {
        play->final_score = calculateScore(board, play);
    }
}

void startGame(struct Play* play) {
    play->start_timestamp = time(NULL);
}

void exitGame(struct Play* play) {
    play->end_timestamp = time(NULL);
    play->duration = play->end_timestamp - play->start_timestamp;
}

int extractInput(const char* buf, const char* fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    int rc = vsscanf(buf, fmt, ap);
    va_end(ap);
    return rc;
}

void logScore(struct Play* play) {
    FILE* fptr;
    fptr = fopen("scores.log", "a");
    fprintf(fptr, "%s %d %lu %.2f %d %d %d\n", play->player, play->final_score, play->duration, play->score, play->bombs, play->lives, play->status);
    fclose(fptr);
}

void displayTopScores(int n) {
    struct Play* plays = malloc(sizeof(struct Play));
    struct Play play;
    int size = 0;

    FILE* fptr;
    fptr = fopen("scores.log", "r");
    while (fscanf(fptr, "%s %d %lu %f %d %d %d\n", play.player, &play.final_score, &play.duration, &play.score, &play.bombs, &play.lives, &play.status) != EOF) {
        size++;
        plays = realloc(plays, sizeof(struct Play) * size);
        memcpy(&plays[size - 1], &play, sizeof(struct Play));
    }
    fclose(fptr);

    // Bubble Sort
    for (int t = 0; t < size; t++) {
        for (int r = 0; r < size - 1; r++) {
            if (plays[r].final_score < plays[r + 1].final_score) { // The greater ones should be at the top
                // Swap two Plays
                struct Play py = plays[r];
                plays[r] = plays[r + 1];
                plays[r + 1] = py;
            }
        }
    }

    int times = min(size, n);
    for (int t = 0; t < times; t++) {
        play = plays[t];
        printf("%s %d %lu %.2f %d %d %d\n", play.player, play.final_score, play.duration, play.score, play.bombs, play.lives, play.status);
    }
}

int main(int argc, char* argv[]) {

    time_t timestamp;
    srand((unsigned)time(&timestamp));

    clear_screen();

    struct Board board;
    struct Play play;
    board.row = 15;
    board.column = 15;

    printf("Board: \n");

    initializeGame(&board, &play);
    displayGame(&board, &play, true);

    printf("\nPress ENTER key to start game...");
    getchar();

    char input[10];
    int x = -10, y = -10;

    startGame(&play);

    do {
        clear_screen();
        displayGame(&board, &play, false);

        printf("\n");
        printf("Enter q to quit, \n");
        printf("Enter bomb position (x y): ");
        gets(input);

        if (extractInput(input, "%d %d", &x, &y) == 2) {
            playGame(&board, &play, x, y);
        } else if (input[0] == 'q') {
            play.status = QUIT;
        }

        printf("\n");
    } while (play.status == GAMING);

    exitGame(&play);

    clear_screen();
    displayGame(&board, &play, false);
    printf("\n");

    if (play.status == DIE) {
        style(RED, true);
        printf("You die. T_T\n");
        style(CLEAR, false);
    } else if (play.status == WIN) {
        style(GREEN, true);
        printf("You win! ^o^\n");
        style(CLEAR, false);
    } else if (play.status == QUIT) {
        style(BLUE, true);
        printf("You quit. *_*\n");
        style(CLEAR, false);
    }

    printf("\n");

    printf("press ENTER to continue...");
    getchar();
    printf("\n");

    if (play.status != QUIT) {
        clear_screen();

        style(CYAN, true);
        printf("Logging:\n\n");
        style(CLEAR, false);

        printf("Please enter your name (no space): ");
        scanf("%s", play.player);
        logScore(&play);
    }

    clear_screen();

    printf("Your game time is: %lus\n", play.duration);
    printf("Your score is: %d pts\n", play.final_score);


}
