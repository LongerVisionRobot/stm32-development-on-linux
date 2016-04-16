#include "stm32f10x.h"
#include "usart.h"
#include "lib_headers_stm32.h"
// To use printf(), you do not need to include stdio.h because I use newlib

int main(void) {
	int a, b;
	InitUart();
	while (1) {
		printf("Please input two interger:\n");
		scanf("%d %d", &a, &b);
		printf("%d + %d = %d\n", a, b, a + b);
	}
}
