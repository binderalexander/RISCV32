#include <stdbool.h>

#define ADDR_LEDS   ((char *) 0x40000000)
#define ADDR_SWITCH ((char *) 0x40000010)

bool ledState = false;

void toggleLeds(){

    if(ledState){
        *(ADDR_LEDS + 1) = 0x2;
    } else {
        *(ADDR_LEDS + 1) = 0x1;
    }

    ledState = !ledState;
}

int main(){
    char *pLeds      = ADDR_LEDS;
    char *pSwitches  = ADDR_SWITCH;
    long i = 0;

    while(1){
        *pSwitches = *pLeds;

        if (i == 1000000) {
            toggleLeds();
            i = 0;
        } else {
            i++;
        }

    }

    return 0;
}
