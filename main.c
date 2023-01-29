#include "stdio.h"
#include "malloc.h"
#include "time.h"

char* alphabet_position(char *text);
long long count_ones(int left, int right);
long long count_ones_cheat(int left, int right);

int main(int argc, char* args[]) {
	char* text[] = {"RURANCGUNYJDDFEITDFJSNNRUQAASTZLPTNCXWZLWKQZPVKKYRUSEHLAZLBTGCEVVUATQZEMJWNARZLRQHLWQWXRIALOCRMYLMTDNXRYVFYNGLGZSUVKQUCAUNPZEBXSPQVCPNAKUAZAMIZGCXRSRVTOKKNONMICEEETTGFNGHPUPRDRQWLH",
    "AAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz234566yvbQQ",
	"Some meaningful text, special for Vadim showcase :)"};

    //Testing for "alphabet_position" routine 
    //{
	char* out;

    printf("**** Testing for \"alphabet_position\" routine ****\n\n");

    printf("test string: %s\n\n",*(text));
	out = alphabet_position(*(text));
	printf("out text: %s\n\n",out);
	free((void*)out);

	printf("test string: %s\n\n",*(text+1));
	out = alphabet_position(*(text+1));
	printf("out text: %s\n\n",out);
	free((void*)out);

	printf("test string: %s\n\n",*(text+2));
	out = alphabet_position(*(text+2));
	printf("out text: %s\n\n",out);
	free((void*)out);
    //}

    //Testing for "count_ones" routine
    //{
    printf("**** Testing for \"count_ones\" routine ****\n\n");
    clock_t bg;
    clock_t nd;

    printf("Optimized count_ones start...\n");
    bg = clock();

    long long rez = count_ones(1, 1000000000);
	printf("Expected (14846928141): %llu\n", rez);
	rez = count_ones(122858165, 239316350);
	printf("Expected (1663772824): %llu\n", rez);

    nd = clock();
    double tm = (double)(nd - bg) * 1000.0 / CLOCKS_PER_SEC;
    printf("Exec. time %f ms\n\n", tm);

    printf("Not optimized count_ones start...\n");
    bg = clock();

    rez = count_ones_cheat(1, 1000000000);
	printf("Expected (14846928141): %llu\n", rez);
	rez = count_ones_cheat(122858165, 239316350);
	printf("Expected (1663772824): %llu\n", rez);

    nd = clock();
    tm = (double)(nd - bg) * 1000.0 / CLOCKS_PER_SEC;
    printf("Exec. time %f ms\n\n", tm);
    //}
	return 0;
}
