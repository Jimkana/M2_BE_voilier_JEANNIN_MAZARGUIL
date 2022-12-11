/* 
 * "Small Hello World" example. 
 * 
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example 
 * designs. It requires a STDOUT  device in your system's hardware. 
 *
 * The purpose of this example is to demonstrate the smallest possible Hello 
 * World application, using the Nios II HAL library.  The memory footprint
 * of this hosted application is ~332 bytes by default using the standard 
 * reference design.  For a more fully featured Hello World application
 * example, see the example titled "Hello World".
 *
 * The memory footprint of this example has been reduced by making the
 * following changes to the normal "Hello World" example.
 * Check in the Nios II Software Developers Manual for a more complete 
 * description.
 * 
 * In the SW Application project (small_hello_world):
 *
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 * In System Library project (small_hello_world_syslib):
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 *    - Define the preprocessor option ALT_NO_INSTRUCTION_EMULATION 
 *      This removes software exception handling, which means that you cannot 
 *      run code compiled for Nios II cpu with a hardware multiplier on a core 
 *      without a the multiply unit. Check the Nios II Software Developers 
 *      Manual for more details.
 *
 *  - In the System Library page:
 *    - Set Periodic system timer and Timestamp timer to none
 *      This prevents the automatic inclusion of the timer driver.
 *
 *    - Set Max file descriptors to 4
 *      This reduces the size of the file handle pool.
 *
 *    - Check Main function does not exit
 *    - Uncheck Clean exit (flush buffers)
 *      This removes the unneeded call to exit when main returns, since it
 *      won't.
 *
 *    - Check Don't use C++
 *      This builds without the C++ support code.
 *
 *    - Check Small C library
 *      This uses a reduced functionality C library, which lacks  
 *      support for buffering, file IO, floating point and getch(), etc. 
 *      Check the Nios II Software Developers Manual for a complete list.
 *
 *    - Check Reduced device drivers
 *      This uses reduced functionality drivers if they're available. For the
 *      standard design this means you get polled UART and JTAG UART drivers,
 *      no support for the LCD driver and you lose the ability to program 
 *      CFI compliant flash devices.
 *
 *    - Check Access device drivers directly
 *      This bypasses the device file system to access device drivers directly.
 *      This eliminates the space required for the device file system services.
 *      It also provides a HAL version of libc services that access the drivers
 *      directly, further reducing space. Only a limited number of libc
 *      functions are available in this configuration.
 *
 *    - Use ALT versions of stdio routines:
 *
 *           Function                  Description
 *        ===============  =====================================
 *        alt_printf       Only supports %s, %x, and %c ( < 1 Kbyte)
 *        alt_putstr       Smaller overhead than puts with direct drivers
 *                         Note this function doesn't add a newline.
 *        alt_putchar      Smaller overhead than putchar with direct drivers
 *        alt_getchar      Smaller overhead than getchar with direct drivers
 *
 */

#include "sys/alt_stdio.h"
#include "system.h"

#include "io.h"
#include <unistd.h>
#include "altera_avalon_pio_regs.h"

#include <stdio.h>
#include <stdint.h>


int main()
{ 
	int loop_count = 0;
	alt_putstr("Hello from Nios II!\n");
	//uint32_t data_cap, config_cap = 0;
	//uint32_t data_anemo, config_anemo = 0;
	//uint32_t data_btn, config_barre = 0;

  /* Event loop never exits. */
  while (1)
      {
          for (int i = 0; i < 8; i++)
          {
              IOWR_32DIRECT(LEDS_BASE, 0, 1 << i);
              usleep(100000);
          }
          for (int i = 0; i < 8; i++)
          {
              IOWR_32DIRECT(LEDS_BASE, 0, 0x80 >> i);
              usleep(100000);
          }
          printf("Loop Count = %d\n", loop_count);
/*
          //Ecriture des données de config sur le bus pour le cap
          IOWR_32DIRECT(BUS_AVALON_0_BASE, 0, config_cap);
          //Lecture des données de la position du cap
          data_cap = IORD_32DIRECT(BUS_AVALON_0_BASE, 4);
          printf("cap : %08lX", data_cap);

          //Ecriture des données de config sur le bus pour l'anemometre
          IOWR_32DIRECT(BUS_AVALON_F2_0_BASE, 0, config_anemo);
          //Lecture des données de la vitesse du vent
          data_anemo = IORD_32DIRECT(BUS_AVALON_F2_0_BASE, 4);
          printf("vitesse du vent : %08lX", data_anemo);

          //Ecriture des données de config sur le bus pour la barre
          IOWR_32DIRECT(BUS_AVALON_F7_0_BASE, 0, config_barre);
          //Lecture des données des boutons
          data_btn = IORD_32DIRECT(BUS_AVALON_F7_0_BASE, 4);
          printf("boutons : %08lX", data_btn);*/
          printf("----------------------------------------\n");


      }
  return 0;
}
