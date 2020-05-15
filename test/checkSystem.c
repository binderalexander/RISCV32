#include <stdint.h>

#define ADDR_LEDS   ((char *) 0x8000)

void runningLeds(){
    static uint8_t cnt = 0;

	*ADDR_LEDS = cnt++;
}

int main(){
    long i = 0;

    while(1){
        if (i == 10000) {
            runningLeds();
            i = 0;
        } else {
            i++;
        }
    }
    return 0;
}
