/*
 * keycall.h
 *
 *  Created on: 2020��12��8��
 *      Author: 45242
 */

#ifndef KEYCALL_H_
#define KEYCALL_H_

int keycall_init(void);
void keycall(short int keycodes[3]);
char getkeys(short int keycodes[3]);

/*
#define key_space unsigned char 44;
#define key_w unsigned char 26;
#define key_a unsigned char 4;
#define key_s unsigned char 22;
#define key_d unsigned char 7;
#define key_j unsigned char 13;
#define key_k unsigned char 14;
*/

#endif /* KEYCALL_H_ */
