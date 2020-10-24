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
#define clearScreen() system("cls"); printf("\ec"); fflush(stdout);
#define color(color) printf("\033[%dm", color);
#define clear() printf("\033[0m");

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

struct Board {
    struct Tile* array;
    unsigned int row;
    unsigned int column;
    unsigned int tiles;
    unsigned int negatives;
    unsigned int specials;
};

struct Play {
    char player[10];
    int lives;
    float score;
    float total_score;
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
    play->total_score = 0.0;
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
    while (board->specials < (int)(board->tiles* SPE_PERCENT)) {
        int index = randomNum(0, board->tiles - 1);
        board->array[index].value = REWARD;
        board->specials++;
    }

    // Generate Exit
    int exitIndex = randomNum(0, board->tiles - 1);
    board->array[exitIndex].value = EXIT;
}


int calculateScore(struct Board* board, struct Play* play) {
    float rate = 1.0 * play->uncovered_tiles / board->tiles;
    float score = play->total_score * 20 + play->bombs * 33 + play->lives * 10;
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
                        play->total_score += value;
                        play->score += value;
                        break;
                    }
                }
            }
        }

        if (play->score < 0) {
            play->lives--;
            play->score = 0;
        }

        if ((play->bombs <= 0 || play->lives <= 0) && play->status != WIN) {
            play->status = DIE;
        }

    }
}

void startGame(struct Play* play) {
    play->start_timestamp = time(NULL);
}

void exitGame(struct Play* play) {
    play->end_timestamp = time(NULL);
    play->duration = play->end_timestamp - play->start_timestamp;

    printf("\n");

    if (play->status == DIE) {
        color(RED);
        printf("------ YOU LOSE T_T ------ \n");
        clear();
    } else if (play->status == WIN) {
        color(GREEN);
        printf("------ YOU WIN! ^0^ ------ \n");
        clear();
    } else if (play->status == QUIT) {
        color(BLUE);
        printf("------ YOU QUIT *_* ------ \n");
        clear();
    }
    printf("\n");
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
    fprintf(fptr, "%s %d %lu %.2f %d %d %d\n", play->player, play->final_score, play->duration, play->total_score, play->bombs, play->lives, play->status);
    fclose(fptr);
}


void displayGame(struct Board* board, struct Play* play, bool peek) {
    static float score;
    static float lives;

    clearScreen();

    if (peek) {
        color(CYAN);
        printf("Board: \n\n");
        clear();
    }

    for (int t = 0; t < board->tiles; t++) {
        int col = t % board->column;
        float value = board->array[t].value;

        if (!board->array[t].covered || peek) {
            switch ((int)value) {
            case REWARD:
            case EXIT:
                if (value == EXIT) color(CYAN) else color(YELLOW);

                if (peek) printf("   %c    ", (int)value);
                else printf("%c  ", (int)value);

                clear();
                break;
            default:
                if (value > 0) color(GREEN) else color(RED);

                if (peek == true) printf("%+6.2f  ", value);
                else printf("%c  ", (value > 0) ? '+' : '-');

                clear();
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
        printf("Lives: %d	", play->lives);
        int livesChange = play->lives - lives;
        if (livesChange > 0) color(GREEN) else color(RED);
        if (livesChange != 0) printf("(%+d)", livesChange);
        clear();
        printf("\n");

        printf("Bombs: %d	", play->bombs);
        if (play->range > 1) {
            color(CYAN);
            printf("(Reward: %dx range)", play->range);
            clear();
        }
        printf("\n");

        printf("Score: %.2f	", play->score);
        float scoreChange = play->score - score;
        if (scoreChange > 0) color(GREEN) else color(RED);
        if (scoreChange != 0) printf("(%+.2f)", scoreChange);
        clear();
        printf("\n");

        printf("Total: %.2f	\n", play->total_score);

    }

    score = play->score;
    lives = play->lives;

    printf("\n");

}

void displayTopScores(int n) {
    struct Play* plays = malloc(sizeof(struct Play));
    struct Play play;
    int size = 0;

    FILE* fptr;
    fptr = fopen("scores.log", "r");
    while (fscanf(fptr, "%s %d %lu %f %d %d %d\n", play.player, &play.final_score, &play.duration, &play.total_score, &play.bombs, &play.lives, &play.status) != EOF) {
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

    printf("\n");
    printf("Player        | Final Score | Duration | Total Score | Bombs left | Lives left | Status\n");
    int times = min(size, n);
    for (int t = 0; t < times; t++) {
        play = plays[t];
        printf("%s		%11.d   %8.lu   %11.2f   %10.d   %10.d   %6.d\n", play.player, play.final_score, play.duration, play.total_score, play.bombs, play.lives, play.status);
    }

    printf("\n\n");
}

void displayResult(struct Play* play) {
    clearScreen();

    color(CYAN);
    printf("Logging:\n\n");
    clear();

    printf("Please enter your name (no space): ");
    scanf("%s", play->player);
    printf("\n\n");

    color(CYAN);
    printf("Result:\n\n");
    clear();

    printf("Player        ");
    color(YELLOW);
    printf("%s\n", play->player);
    clear();

    printf("Tiles score   ");
    color(BLUE);
    printf("%.2f pts\n", play->total_score);
    clear();

    printf("Left bombs    ");
    color(BLUE);
    printf("%d\n", play->bombs);
    clear();

    printf("Left lives    ");
    color(BLUE);
    printf("%d\n", play->lives);
    clear();

    printf("Duration      ");
    color(BLUE);
    printf("%lu s\n", play->duration);
    clear();

    printf("Final score   ");
    color(YELLOW);
    printf("%d pts\n", play->final_score);
    clear();

    printf("\n\n");
}

void displayAskTopScores() {

    clearScreen();

    color(CYAN);
    printf("Top Scores:\n\n");
    clear();

    int n;
    printf("You can check top scores here.\n\n");
    printf("Enter 0 to skip,\n");
    printf("How many top scores to check? ");
    scanf("%d", &n);
    fflush(stdin);

    if (n > 0) {
        displayTopScores(n);

        printf("Press ENTER to continue... ");
        getchar();
    }

    printf("\n");
}

int main(int argc, char* argv[]) {
    time_t timestamp;
    srand((unsigned)time(&timestamp));

    displayAskTopScores();

    struct Board board;
    struct Play play;
    board.row = 15;
    board.column = 15;

    initializeGame(&board, &play);
    displayGame(&board, &play, true);

    printf("Press ENTER key to start game...");
    getchar();

    char input[10];
    int x = -10, y = -10;

    startGame(&play);

    do {
        displayGame(&board, &play, false);

        printf("Enter q to quit, \n");
        printf("Enter bomb position (x y): ");
        gets(input);

        if (extractInput(input, "%d %d", &x, &y) == 2) {
            playGame(&board, &play, x, y);
        } else if (input[0] == 'q') {
            play.status = QUIT;
        }
    } while (play.status == GAMING);

    displayGame(&board, &play, false);
    exitGame(&play);
    calculateScore(&board, &play);

    printf("press ENTER to continue...");
    getchar();

    if (play.status != QUIT) {
        logScore(&play);
        displayResult(&play);
    }

    displayAskTopScores();

    clearScreen();
    color(CYAN);
    printf("Thanks for playing. Have a nice day! \n\n");
    clear();

}
