// myboard.h

// setting first overrides the value in the default header
/* 
Let's support generic Flash memory so to keep the code compatible with 
all Pico clones, we need to set the following define to 1
*/
#define PICO_BOOT_STAGE2_CHOOSE_GENERIC_03H 1

//#define PICO_FLASH_SPI_CLKDIV 2     // use for winbond flash
#define PICO_FLASH_SPI_CLKDIV 4     // use for slower flash (e.g. zbit)

// pick up the rest of the settings
#include "boards/pico.h"
