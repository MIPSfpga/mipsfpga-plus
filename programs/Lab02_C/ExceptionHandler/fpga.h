/*
 * fpga.h
 *
 *  Created on: Dec 6, 2014
 *      Author: MIPS TECHNOLOGIES, INC
 */

#ifndef FPGA_H_
#define FPGA_H_

#define IO_LEDR        0xBF800000
#define IO_LEDG        0xBF800004
#define IO_SWITCHES    0xBF800008
#define IO_PUSHBUTTONS 0xBF80000C
#define IO_7SEGEN		0xBF800010
#define IO_7SEG0		0xBF800014
#define IO_7SEG1		0xBF800018
#define IO_7SEG2		0xBF80001C
#define IO_7SEG3		0xBF800020
#define IO_7SEG4		0xBF800024
#define IO_7SEG5		0xBF800028
#define IO_7SEG6		0xBF80002C
#define IO_7SEG7		0xBF800030
#define IO_MILLIS		0xBF800034
#define IO_SPI_DATA	0xBf80003C
#define IO_SPI_DONE	0xBf800040


#define BOARD_16_LEDS_ADDR     0xBF800000  //used by exception handlers

#define READ_IO(addr)  (volatile unsigned int *)(addr)
#define WRITE_IO(addr) (volatile unsigned int *)( addr)

#define STACK_BASE_ADDR 0x80040000;  //Change: End of kseg0 memory based on size of 256KB

#endif /* FPGA_H_ */
