## Upload the board using uart
## Usage: in sub-programs directory (eg. 00_counter) type "sh ../linux_scripts/12_upload_to_the_board_using_uart.sh"
## @author Andrea Guerrieri - andrea.guerrieri@studenti.polito.it ing.guerrieri.a@gmail.com
## @file 12_upload_to_the_board_using_uart.sh

stty -F /dev/ttyUSB0 raw speed 115200 -crtscts cs8 -parenb -cstopb
cat program.rec > /dev/ttyUSB0