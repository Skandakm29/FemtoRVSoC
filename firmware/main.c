#define UART_BASE       0x82000800
#define UART_RXTX       (*(volatile unsigned int*)(UART_BASE + 0x00))
#define UART_TXFULL     (*(volatile unsigned int*)(UART_BASE + 0x04))

void uart_putchar(char c) {
    while (UART_TXFULL); // Wait if TX is full
    UART_RXTX = c;
}

void uart_puts(const char* str) {
    while (*str) {
        uart_putchar(*str++);
    }
}

int main() {
    uart_puts("Hello from VSD Mini FPGA!\n");
    while (1);
    return 0;
}
