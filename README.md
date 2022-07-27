# UART_RX
 UART TX receive a UART frame on S_DATA.
* UART_RX support oversampling by 8
* S_DATA is high in the IDLE case (No transmission).
* PAR_ERR signal is high when the calculated parity bit not equal 
the received frame parity bit as this mean that the frame is 
corrupted.
* STP_ERR signal is high when the received stop bit not equal 1 as 
this mean that the frame is corrupted.
* DATA is extracted from the received frame and then sent 
through P_DATA bus associated with DATA_VLD signal only after 
checking that the frame is received correctly and not corrupted.
(PAR_ERR = 0 && STP_ERR = 0).
* UART_RX can accept consequent frames.
* Registers are cleared using asynchronous active low reset

* PAR_EN (Configuration)
  * 0: To disable frame parity bit 
  * 1: To enable frame parity bit

* PAR_TYP (Configuration)
  * 0: Even parity bit 
  * 1: Odd parity bit
