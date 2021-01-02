/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000040;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *  
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *  
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
void AES(uchar * in, uchar * out, uint * w);
void AddRoundKey(uchar state[][4], uint * word);
void SubBytes(uchar state[][4]);
void ShiftRows(uchar state[][4]);
void MixColumns(uchar state[][4]);
void KeyExpansion(uchar * key, uint * w);
uint SubWord(uint word);
uint RotWord(uint word);
void printstate(uchar state[][4]){
	printf("\nstate:\n");
	int i, j;
	for(i = 0; i < 4; i++){
		for(j = 0; j < 4; j++){
			printf("%02x ", state[i][j]);
		}
		printf("\n");
	}
	printf("\n");
}
void printbyte(uchar* byte){
	int i;
	for(i = 0; i < 16; i++){
		printf("%02x", byte[i]);
	}
	printf("\n");
}
void printword(uint* word){
	int i;
	for(i = 0; i < 4; i++){
		printf("%08x", word[i]);
	}
	printf("\n");
}
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	int i, j;
	uchar in[16], out[16], key_byte[16];
	uint w_word[44];

	for (i = 0; i < 16; i++){
		in[i] = (uchar)charsToHex(*(msg_ascii + 2 * i), *(msg_ascii + 2 * i + 1));
		key_byte[i] = (uchar)charsToHex(*(key_ascii + 2 * i), *(key_ascii + 2 * i + 1));
	}
	//printf("\nIn Encrypt:\n");
	KeyExpansion(key_byte, w_word);
	AES(in, out, w_word);
	/*
	printf("\nKeyExpansion:\n");
	for(i = 0; i < 11; i++){
		for(j = 0; j < 4; j++){
			printf("%08x", w_word[i * 4 + j]);
		}
		printf("\n");
	}
	printf("\n");
	*/
	for(i = 0; i < 4; i++){
		msg_enc[i] = ((uint)out[4 * i] << 24 & 0xff000000)
					+ ((uint)out[4 * i + 1] << 16 & 0x00ff0000)
					+ ((uint)out[4 * i + 2] << 8 & 0x0000ff00)
					+ ((uint)out[4 * i + 3] & 0x000000ff);
		key[i] = ((uint)key_byte[4 * i] << 24 & 0xff000000)
					+ ((uint)key_byte[4 * i + 1] << 16 & 0x00ff0000)
					+ ((uint)key_byte[4 * i + 2] << 8 & 0x0000ff00)
					+ ((uint)key_byte[4 * i + 3] & 0x000000ff);
	}
}
void AES(uchar * in, uchar * out, uint * w){
	int i, j;
	int round;
	uchar state[4][4];
	//printf("\nAES:\n");
	for (j = 0; j < 4; j++){
		for (i = 0; i < 4; i++){
			state[i][j] = in[j * 4 + i];
		}
	}
	AddRoundKey(state, w);
	for(round = 1; round < 10; round++){
		SubBytes(state);
		ShiftRows(state);
		MixColumns(state);
		AddRoundKey(state, w + round * 4);
	}
	SubBytes(state);
	ShiftRows(state);
	AddRoundKey(state, w + 40);
	for (j = 0; j < 4; j++){
		for (i = 0; i < 4; i++){
			out[j * 4 + i] = state[i][j];
		}
	}
}
void KeyExpansion(uchar * key, uint * w){
	uint temp;
	int i;
	for(i = 0; i < 4; i++){
		w[i] = ((uint)key[4 * i] << 24 & 0xff000000)
				+ ((uint)key[4 * i + 1] << 16 & 0x00ff0000)
				+ ((uint)key[4 * i + 2] << 8 & 0x0000ff00)
				+ ((uint)key[4 * i + 3] & 0x000000ff);
	}
	for(i = 4; i < 44; i++){
		temp = w[i - 1];
		if (0 == i % 4){
			temp = SubWord(RotWord(temp)) ^ Rcon[i / 4];
		}
		w[i] = w[i - 4] ^ temp;
	}
}
uint SubWord(uint word){
	uint out_word;
	out_word = ((uint)aes_sbox[(uchar)(word >> 24)] << 24 & 0xff000000)
					| ((uint)aes_sbox[(uchar)(word >> 16)] << 16 & 0x00ff0000)
					| ((uint)aes_sbox[(uchar)(word >> 8)] << 8 & 0x0000ff00)
					| ((uint)aes_sbox[(uchar)(word)] & 0x000000ff);
	return out_word;
}
uint RotWord(uint word){
	uint out_word;
	out_word = (word << 8) | (word >> 24);
	return out_word;
}
void AddRoundKey(uchar state[][4], uint * word){
	int i, j;
	uchar *inv_word_byte = (uchar*) word;
	for (j = 0; j < 4; j++){
		for (i = 0; i < 4; i++){
			state[i][j] ^= *(inv_word_byte + 3 - i + 4 * j);
		}
	}
}
void SubBytes(uchar state[][4]){
	int i, j;
	for(j = 0; j < 4; j++){
		for(i = 0; i < 4; i++){
			state[i][j] = aes_sbox[state[i][j]];
		}
	}
}
void ShiftRows(uchar state[][4]){
	uchar temp;
	temp = state[1][0];
	state[1][0] = state[1][1];
	state[1][1] = state[1][2];
	state[1][2] = state[1][3];
	state[1][3] = temp;

	temp = state[2][0];
	state[2][0] = state[2][2];
	state[2][2] = temp;
	temp = state[2][1];
	state[2][1] = state[2][3];
	state[2][3] = temp;

	temp = state[3][0];
	state[3][0] = state[3][3];
	state[3][3] = state[3][2];
	state[3][2] = state[3][1];
	state[3][1] = temp;
}
void MixColumns(uchar state[][4]){
	uchar newstate[4][4];
	int i, j;
	for(j = 0; j < 4; j++){
		for(i = 0; i < 4; i++){
			newstate[i][j] = gf_mul[state[i][j]][0] ^ gf_mul[state[(i + 1) % 4][j]][1] ^ state[(i + 2) % 4][j] ^ state[(i + 3) % 4][j];
		}
	}
	for(j = 0; j < 4; j++){
		for(i = 0; i < 4; i++){
			state[i][j] = newstate[i][j];
		}
	}
}
/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	int i;
	//test
	/*
	printf("\nIn decryption:\n");
	printf("msg_enc:\n");
	printword(msg_enc);
	printf("key:\n");
	printword(key);
	printf("msg_dec:\n");
	printword(msg_dec);
	*/
	for(i = 0; i < 4; i++){
		AES_PTR[i] = key[i];
		AES_PTR[i + 4] = msg_enc[i];
	}
	AES_PTR[14] = 1;
	while(1){
		if(AES_PTR[15] == 1){
			//printf("Done");
			break;
		}
	}
	AES_PTR[14] = 0;
	for(i = 0; i < 4; i++){
		msg_dec[i] = AES_PTR[i + 8];
	}
	/*
	printf("msg_dec:\n");
	printword(msg_dec);
	AES_PTR[12] = 0xDEADBEEF;
	printf("Print AES_PTR:\n");
	for(i = 0; i < 16; i++){
		printf("%08x\n", AES_PTR[i]);
	}
	if (AES_PTR[12] != 0xDEADBEEF){
		printf("Error\n");
		//return;
	}
	*/
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33] = "ece298dcece298dcece298dcece298dc";
	unsigned char key_ascii[33] = "000102030405060708090a0b0c0d0e0f";
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);
	//int run_mode = 0;
	if (run_mode == 0) {

		// Continuously Perform Encryption and Decryption
		/*
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
		*/

			int i = 0;
			printf("\nEnter Message:\n");
			printf("%s\n", msg_ascii);
			printf("\nEnter Key:\n");
			printf("%s\n", key_ascii);
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");

	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}
