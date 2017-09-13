## Upload the board using uart
## Usage: in sub-programs directory (eg. 00_counter) type "sh ../linux_scripts/12_upload_to_the_board_using_uart.sh"
## @author Andrea Guerrieri - andrea.guerrieri@studenti.polito.it ing.guerrieri.a@gmail.com
## @file 12_upload_to_the_board_using_uart.sh

USBDEV=/dev/ttyUSB0

stty -F $USBDEV raw speed 115200 -crtscts cs8 -parenb -cstopb
cat program.rec > $USBDEV
