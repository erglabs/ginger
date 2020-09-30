#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#define XLIM 17
#define YLIM 9
#define ARSZ (XLIM * YLIM)

#define DEBUG 0

static uint16_t array[ARSZ];

const char symbols[] = {
    ' ', '.', 'o', '+',
    '=', '*', 'B', 'O',
    'X', '@', '%', '&',
    '#', '/', '^', 'S', 'E'
};

void print_graph(void)
{
    uint8_t i;
    uint8_t j;
    uint16_t temp;

    printf("+--[ RandomArt ]--+\n");

    for (i = 0; i < YLIM; i++) {
        printf("|");
        for (j = 0; j < XLIM; j++) {
            temp = array[j + XLIM * i];
            printf("%c", symbols[temp]);
        }
        printf("|\n");
    }

    printf("+-----------------+\n");
}

static char string[256];

static int ishex (char c)
{
    if ((c >= '0' && c <= '9') ||
        (c >= 'A' && c <= 'F') ||
        (c >= 'a' && c <= 'f')) {
            return 1;
    }

    return 0;
}

/*
 * The hexval function expects a hexadecimal character in the range
 * [0-9], [A-F] or [a-f]. Passing any other character will result in
 * undefined behaviour. Make sure you validate the character first.
 */
static uint8_t hexval (char c)
{
    if (c <= '9') {
        return (c - '0');
    } else if (c <= 'F') {
        return (c - 'A' + 10);
    } else if (c <= 'f') {
        return (c - 'a' + 10);
    }

    return 0;
}

int convert_string(char *arg)
{
    uint16_t i;
    char c;

    i = 0;
    while (*arg && i < 255) {
        c = *arg;
        if (!ishex(c)) {
            printf("Unrecognized character '%c'\n", c);
            return 1;
        }
        arg++;

        string[i] = hexval(c) << 4;

        if (!*arg) {
            printf("Odd number of characters\n");
            return 1;
        }
        c = *arg;

        if (!ishex(c)) {
            printf("Unrecognized character '%c'\n", c);
            return 1;
        }
        arg++;

        string[i] |= hexval(c);
        i++;
    }

    // Add the terminating null byte
    string[i] = '\0';
    return 0;
}

uint8_t new_position(uint8_t *pos, uint8_t direction)
{
    uint8_t newpos;
    uint8_t upd = 1;
    int8_t x0;
    int8_t y0;
    int8_t x1;
    int8_t y1;

    x0 = *pos % XLIM;
    y0 = *pos / XLIM;

    #if DEBUG
    printf("At position (%2d, %2d)... ", x0, y0);
    #endif

    switch (direction) {
        case 0: // NW
            #if DEBUG
            printf("Moving NW... ");
            #endif
            x1 = x0 - 1;
            y1 = y0 - 1;
            break;
        case 1: // NE
            #if DEBUG
            printf("Moving NE... ");
            #endif
            x1 = x0 + 1;
            y1 = y0 - 1;
            break;
        case 2: // SW
            #if DEBUG
            printf("Moving SW... ");
            #endif
            x1 = x0 - 1;
            y1 = y0 + 1;
            break;
        case 3: // SE
            #if DEBUG
            printf("Moving SE... ");
            #endif
            x1 = x0 + 1;
            y1 = y0 + 1;
            break;
        default: // Should never happen
            #if DEBUG
            printf("INVALID DIRECTION %d!!!", direction);
            #endif
            x1 = x0;
            y1 = y0;
            break;
    }

    // Limit the range of x1 & y1
    if (x1 < 0) {
        x1 = 0;
    } else if (x1 >= XLIM) {
        x1 = XLIM - 1;
    }

    if (y1 < 0) {
        y1 = 0;
    } else if (y1 >= YLIM) {
        y1 = YLIM - 1;
    }

    newpos = y1 * XLIM + x1;
    #if DEBUG
    printf("New position (%2d, %2d)... ", x1, y1);
    #endif

    if (newpos == *pos) {
        #if DEBUG
        printf("NO CHANGE");
        #endif

        upd = 0;
    } else {
        *pos = newpos;
    }

    #if DEBUG
    printf("\n");
    #endif

    return upd;
}

void drunken_walk(void)
{
    uint8_t pos;
    uint8_t upd;
    uint16_t idx;
    uint8_t i;
    uint8_t temp;

    pos = 76;
    for (idx = 0; string[idx]; idx++) {
        temp = string[idx];

        #if DEBUG
        printf("Walking character index %d ('%02x')...\n", idx, temp);
        #endif

        for (i = 0; i < 4; i++) {
            upd = new_position(&pos, temp & 3);
            if (upd) {
                array[pos]++;
            }
            temp >>= 2;
        }
    }

    array[pos] = 16; // End
    array[76] = 15; // Start
}

int main(int argc, char *argv[])
{
    if (argc != 2) {
        printf("Usage: bishop <hex string>\n");
        return 1;
    }

    if (convert_string(argv[1])) {
        printf("String conversion failed!\n");
        return 1;
    }

    drunken_walk();
    print_graph();

    return 0;
}
