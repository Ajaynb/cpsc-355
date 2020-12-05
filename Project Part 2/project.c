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

// Define some helper functions
#define clearScreen() system("cls"); printf("\ec"); // Clear the terminal texts
#define color(color) printf("\033[%dm", color);     // print color texts in the terminal
#define clear() printf("\033[0m");                  // clear the color text format
#define clean() while ((getchar()) != '\n');        // clean the stdin values

// Define minimum row and column, avoid magic numbers
#define MIN_ROW 10
#define MIN_COL 10
#define MIN_TIL 0.01
#define MAX_TIL 15.00

// Define negatives and specials percentage, avoid magic numbers
#define NEG_PERCENT 0.4
#define SPE_PERCENT 0.2

// Define special tile types
#define EXIT '*'
#define DOUBLE_RANGE '$'
#define EXTRA_BOMB '@'
#define LUCKY_SCORE '!'
#define WHAT_THE_HECK '?'

// Define gaming status
#define PREPARE 0
#define GAMING 1
#define WIN 2
#define DIE 3
#define QUIT 4

// Define color values for stdout
#define RED 31
#define GREEN 32
#define YELLOW 33
#define BLUE 34
#define CYAN 36

/**
 * Define gaming board
 *
 * The game board contains all the tiles and relative informations.
 */
struct Board {
    struct Tile* array;     // The tile array
    unsigned int row;       // number of row
    unsigned int column;    // number of column
    unsigned int tiles;     // total number of tiles
    unsigned int negatives; // total number of negatives
    unsigned int specials;  // total number of specials
};

/**
 * Define gaming tile
 *
 * The gaming tile contains the tile value and its covered status.
 */
struct Tile {
    float value;  // The tile value, from -15.00 to 15.00, exclude 0.00
    bool covered; // If the tile is uncovered
};

/**
 * Define gaming play
 *
 * The gaming play contains the playing status of the current player.
 * This is different from gaming board.
 * It is also used to sort top scores, as the read data would all put into
 * this Play objects.
 */
struct Play {
    char player[100];  // Player name
    int lives;         // Lives left
    float score;       // Current life score
    float total_score; // Total uncovered tile score
    int bombs;         // bombs left
    int range;         // bomb range
    int status;        // gaming status, see above constants
    unsigned long start_timestamp;  // start timestamp
    unsigned long end_timestamp;    // end timestamp
    unsigned long duration;         // gaming duration, subtraction from the two above
    unsigned int uncovered_tiles;   // total number of uncovered tiles
    int final_score;                // calculated final score
};

/**
 * Generate random number between the given range, inclusive.
 *
 * Firstly, get the smallest 2^x number that is larger than the upper bound,
 * and then use this number by and operation and get the remainder.
 * The remainder is the temporary number, then check if the remainder falls within the bounds.
 * If falls winthin, then return. Otherwise, generate another one, until satisfied.
 */
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

    // Generate random number, generate until within the bounds
    int remainder = -1;
    while (!(lower <= remainder && remainder <= upper)) {
        remainder = (rand() & (modular - 1)) + lower;
    }

    return remainder;
}

/**
 * Initialize the game board and play
 *
 * Firstly, populate all the tiles with positive random numbers.
 * Then, calculate how many negative tiles are needed and
 * flip that number of tiles. By fliping, simply multiply -1.
 * Thirdly, flip tiles to special tiles. Simply assign new value.
 *
 * The board->array, the tile array, is a 1-d array, but used as a 2-d.
 * Simply convert between 1-d array index to x and y by math.
 */
void initializeGame(struct Board* board, struct Play* play) {
    // Ensure the board is at least the minimum size
    board->row = max(MIN_ROW, board->row);
    board->column = max(MIN_COL, board->column);

    // Intialize map by allocating memory
    board->tiles = board->row * board->column;
    board->array = calloc(sizeof(struct Tile), board->tiles);

    // Initialize statistics, giving default values
    board->negatives = 0;
    board->specials = 0;
    play->lives = 3;
    play->score = 0.0;
    play->total_score = 0.0;
    play->bombs = board->tiles * 0.05;
    play->range = 1;
    play->status = PREPARE;
    play->uncovered_tiles = 0;

    // Populate board with random positive values
    for (int t = 0; t < board->tiles; t++) {
        int type = randomNum(0, 9);
        float value = randomNum(0, 15) + randomNum(0, 99) * 0.01; // eg: 14 + (35 * 0.01) = 14.35
        value = min(MAX_TIL, value); // check upper bound, cannot be greater than 15.00
        value = max(MIN_TIL, value); // check lower bound, cannot be smaller than 0.01

        struct Tile bl;
        bl.value = value;
        bl.covered = true;

        board->array[t] = bl;
    }

    // Flip to negative numbers
    while (board->negatives < (int)(board->tiles * NEG_PERCENT)) {
        int index = randomNum(0, board->tiles - 1);
        if (board->array[index].value >= 0) { // Only flips the tiles that are positive values, avoid repeating
            board->array[index].value *= -1;
            board->negatives++;
        }
    }

    // Flip to specials
    while (board->specials < (int)(board->tiles * SPE_PERCENT)) {
        int index = randomNum(0, board->tiles - 1);
        int type = randomNum(0, 20);
        if (type == 2) { // About 1/20 chance to get extra bomb tile
            board->array[index].value = EXTRA_BOMB;
        } else if (type == 1) { // About 1/20 chance to get lucky score
            board->array[index].value = LUCKY_SCORE;
        } else if (type == 3) { // About 1/20 chance to get what the heck
            board->array[index].value = WHAT_THE_HECK;
        } else {
            board->array[index].value = DOUBLE_RANGE;
        }
        board->specials++;
    }

    // Generate Exit
    int exitIndex = randomNum(0, board->tiles - 1);
    board->array[exitIndex].value = EXIT;
}

/**
 * Calculate the final score of play
 *
 * It calculates a comprehensive score for the game.
 *
 * According to the formula, by doing the following would get a higher mark:
 * 1. Uncover more tiles
 * 2. Get higher uncover tile score
 * 3. Use less bombs to win
 * 4. Keep more lives to win
 * 5. Use less time to win
 *
 * The following formula gives player a relatively fair score.
 * If the score is less than 0, then just simply count as 0.
 */
int calculateScore(struct Board* board, struct Play* play) {
    float rate = 1.0 * play->uncovered_tiles / board->tiles;
    float score = play->total_score * 20 + play->bombs * 33 + play->lives * 10;
    float time_deduct = play->duration * 46;
    int final_score = rate * score - time_deduct;
    play->final_score = final_score > 0 ? final_score : 0;
    return play->final_score;
}

/**
 * Select position and place bomb.
 *
 * Only when the x and y values are within the board and the current status is gaming,
 * invalid x and y would be ignored and this round would be ignored. So no effect if user
 * accidently input incorrect value, everything (eg. double ranged bomb) will be saved
 * for the next time, always.
 *
 * Using for loop with range to uncover tiles.
 */
void playGame(struct Board* board, struct Play* play, const int x, const int y) {
    // Check both x and y values within the board and gaming status
    if (x >= 0 && x < board->row && y >= 0 && y < board->column && play->status == GAMING) {
        // Reset range and deduct bomb by one
        int range = play->range;
        play->range = 1;
        play->bombs--;

        // For loop to uncover tiles, with range
        for (int t = range * -1; t <= range; t++) { // eg. range = 2, then -2 <= t <= 2
            for (int r = range * -1; r <= range; r++) {
                int new_x = x + t;   // surrounding tiles x
                int new_y = y + r;   // surrounding tiles y
                int index = (new_x * board->column) + new_y;  // surrounding tiles index

                if (index >= 0 && index < board->tiles &&     // If the index is within the board
                    new_y >= 0 && new_y < board->column &&    // and if y is within the column size (force it to stay in the same row, avoid uncover to next row bug)
                    board->array[index].covered) {            // and if this tile is still covered, avoid repeat uncover
                    board->array[index].covered = false;
                    float value = board->array[index].value;
                    play->uncovered_tiles++;

                    // Do different things when meet different tiles
                    switch ((int)value) {
                    case DOUBLE_RANGE:
                        play->range *= 2;
                        break;
                    case LUCKY_SCORE:
                        play->total_score += 10000;
                        break;
                    case EXTRA_BOMB:
                        play->bombs++;
                        break;
                    case WHAT_THE_HECK:
                        play->status = WIN;
                        play->score = 1000000;
                        play->total_score = 1000000;
                        play->final_score = 1000000;
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

        // If the current life score is negative number, then lose a life and reset the score.
        if (play->score < 0) {
            play->lives--;
            play->score = 0;
        }

        // If the player is running out of bombs, or lives, then die.
        // Also need to see if the game status is not win (from above), 
        // because there's possibility that player is winning this round 
        // but also run out of lives or bombs, but we're saying the player is winning.
        if ((play->bombs <= 0 || play->lives <= 0) && play->status != WIN) {
            play->status = DIE;
        }

    }
}

/**
 * Start game
 *
 * Record the start timestamp and set the status to gaming.
 */
void startGame(struct Play* play) {
    play->status = GAMING;
    play->start_timestamp = time(NULL);
}

/**
 * Exit game
 *
 * Record end timestamp and calculate gaming duration.
 * Print user message.
 */
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

/**
 * Extract user input
 *
 * By giving a format string and value string, we could extract
 * values from it conviniently. See README.md for reference.
 */
int extractInput(const char* buf, const char* fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    int rc = vsscanf(buf, fmt, ap);
    va_end(ap);
    return rc;
}

/**
 * Log the score to file
 *
 * Open the log file and append the score.
 */
void logScore(struct Play* play) {
    FILE* fptr;
    fptr = fopen("scores.log", "a");
    fprintf(fptr, "%s %d %lu %.2f %d %d %d\n", play->player, play->final_score, play->duration, play->total_score, play->bombs, play->lives, play->status);
    fclose(fptr);
}

/**
 * Display game
 *
 * Diaplay the board to the user.
 *
 * If the parameter peek is true, then show real tile values.
 * Otherwise, show tiles accordingly.
 *
 * Show relative statistics as well.
 */
void displayGame(struct Board* board, struct Play* play, bool peek) {
    static float score;
    static float lives;
    static int bombs;
    static int status;

    clearScreen();

    if (peek) {
        color(CYAN);
        printf("Board: \n\n");
        clear();
    }

    // Loop all tiles
    for (int t = 0; t < board->tiles; t++) {
        // Calculate the column of the tile
        int col = t % board->column;
        float value = board->array[t].value;

        if (!board->array[t].covered || peek) { // If the tile is not covered or peek, then show value
            // Print tile values with different formats, accordingly
            switch ((int)value) {
            case WHAT_THE_HECK:
                printf("·  ");
                break;
            case LUCKY_SCORE:
            case DOUBLE_RANGE:
            case EXTRA_BOMB:
            case EXIT:
                if (value == EXIT) color(CYAN) else color(YELLOW); // EXIT tile is cyan, others are yellow

                // peek format and gaming format is a little different
                if (peek) printf("   %c    ", (int)value);
                else printf("%c  ", (int)value);

                clear(); // clear text color
                break;
            default:
                if (value > 0) color(GREEN) else color(RED); // Positive values are green and negatives are red

                // peek format and gaming format is a little different
                if (peek == true) printf("%+6.2f  ", value);
                else printf("%c  ", (value > 0) ? '+' : '-');

                clear(); // clear text color
                break;
            }
        } else { // Other wise, show . to hide
            printf("·  ");
        }

        if (col == board->column - 1) { // If it is the last column, then print line break and move to next row
            printf("\n");
        }
    }

    printf("\n");

    if (peek) { // If peek, then print statistic of the board.
        float negRate = (1.0 * board->negatives / board->tiles) * 100;
        printf("Total negatives: %d/%d (%.2f%%)\n", board->negatives, board->tiles, negRate);

        float speRate = (1.0 * board->specials / board->tiles) * 100;
        printf("Total specials:  %d/%d (%.2f%%)\n", board->specials, board->tiles, speRate);

    } else {    // Otherwise, print the current play statistics.
        printf("Lives: %d	", play->lives);
        int livesChange = play->lives - lives;
        if (livesChange > 0) color(GREEN) else color(RED);
        if (livesChange != 0) printf("(%+d)", livesChange); clear();
        printf("\n");

        printf("Bombs: %d	", play->bombs);
        int bombsChange = play->bombs - bombs + 1;
        if (bombsChange > 0 && status == GAMING) {
            color(GREEN);
            printf("(%+d)", bombsChange);
            clear();
        }
        if (play->range > 1) {
            color(CYAN);
            printf("(Reward: %dx range)", play->range);
            clear();
        }
        printf("\n");

        printf("Score: %.2f	", play->score);
        float scoreChange = play->score - score;
        if (scoreChange > 0) color(GREEN) else color(RED);
        if (scoreChange != 0) printf("(%+.2f)", scoreChange); clear();
        printf("\n");

        printf("Total: %.2f	\n", play->total_score);

    }

    score = play->score;
    lives = play->lives;
    bombs = play->bombs;
    status = play->status;

    printf("\n");
}

/**
 * Display top scores.
 *
 * Using bubble sort. Sort and print top scores.
 */
void displayTopScores(int n) {
    struct Play* plays = malloc(sizeof(struct Play));
    struct Play play;
    int size = 0;

    // Read from log file and insert to array
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

    // Print top scores
    printf("\n");
    printf("Player        | Final Score | Duration | Total Score | Bombs left | Lives left | Status\n");
    int times = min(size, n);
    for (int t = 0; t < times; t++) {
        play = plays[t];
        printf("%s		%11.d   %8.lu   %11.2f   %10.d   %10.d   %6.d\n", play.player, play.final_score, play.duration, play.total_score, play.bombs, play.lives, play.status);
    }

    printf("\n\n");
}

/**
 * Display play result
 *
 * Just printing values. Nicely with text colors and formats.
 */
void displayResult(struct Play* play) {
    clearScreen();

    color(CYAN);
    printf("Logging:\n\n");
    clear();

    // printf("Please enter your name (no space): ");
    // scanf("%s", play->player);
    // clean();
    // printf("\n\n");

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
    printf("press ENTER to continue...");
    getchar();
}

/**
 * Display ask top scores
 *
 * Ask user if they want to see top scores.
 */

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
    clean();

    if (n > 0) {
        displayTopScores(n);

        printf("Press ENTER to continue... ");
        getchar();
    }

    printf("\n");
}

void what_the_heck(struct Play* play) {
    FILE* fp;
    char ch, file_name[210];
    if (play->total_score > 100000) {
        fp = fopen("what_the_heck.txt", "r");
        while ((ch = fgetc(fp)) != EOF)
            printf("%c", ch);
        fclose(fp);
    }

}

/**
 * Main functions
 */
int main(int argc, char* argv[]) {
    time_t timestamp;
    srand((unsigned)time(&timestamp));


    // Ask users if they want to see top scores before the game
    displayAskTopScores();

    // Initialize board and play objects
    struct Board board;
    struct Play play;

    // Assign values or default values
    if (argc >= 4) {
        board.row = atoi(argv[1]);
        board.column = atoi(argv[2]);
        strcpy(play.player, argv[3]);
    } else {
        board.row = MIN_ROW;
        board.column = MIN_ROW;
        strcpy(play.player, "player");
    }

    // Intialize and peek the board
    initializeGame(&board, &play);
    displayGame(&board, &play, true);

    printf("Press ENTER key to start game...");
    getchar();



    char input[10];
    int x = -10, y = -10;

    // Start game
    startGame(&play);

    do {
        displayGame(&board, &play, false); // Display board

        printf("Enter q to quit, \n");
        printf("Enter bomb position (x y): ");
        fgets(input, 10, stdin);  // Ask operation

        if (extractInput(input, "%d %d", &x, &y) == 2) {
            playGame(&board, &play, x, y);
        } else if (input[0] == 'q') {
            play.status = QUIT;
        }
    } while (play.status == GAMING);

    // End game, display board and calculate score
    displayGame(&board, &play, false);
    exitGame(&play);
    calculateScore(&board, &play);

    what_the_heck(&play);

    printf("press ENTER to continue...");
    getchar();

    // Show result and log score to file
    if (play.status != QUIT) {
        displayResult(&play);
        logScore(&play);
    }

    // Ask users if they want to see top scores before the game
    displayAskTopScores();

    // End program
    clearScreen();
    color(CYAN);
    printf("Thanks for playing. Have a nice day! \n\n");
    clear();

}