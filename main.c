#include <stdint.h>

#define UART_BASE  0x02000000
#define UART_REG   (*(volatile uint32_t*)(UART_BASE + 0))
#define UART_DIV   (*(volatile uint32_t*)(UART_BASE + 4))
#define LED_REG    (*(volatile uint32_t*)0x03000000)

void delay() {
    for (volatile int i = 0; i < 100000; i++);
}

void main() {
    UART_DIV = 104;         // 115200 baud for 12 MHz clock
    LED_REG = 0b00000010;   // Blue LED ON

    const char* msg = "Hello, RISC-V!\n";
    for (int i = 0; msg[i]; i++) {
        UART_REG = msg[i];
        delay();            // crude wait between bytes
    }

    LED_REG = 0b00000101;   // Red + Green LEDs ON
    while (1);              // loop forever
}
