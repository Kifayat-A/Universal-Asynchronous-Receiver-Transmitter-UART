# UART - Transmitter Module
<img width="1301" height="1282" alt="uart drawio" src="https://github.com/user-attachments/assets/e457a1c3-0a66-4457-89fb-825bcfb90361" />

## PROJECT OVERVIEW
This project implements a UART Transmitter (UART TX) in Verilog HDL with an integrated transmit FIFO.
The design allows a user (CPU / Core / DMA) to write data into the FIFO while the UART transmitter automatically dequeues and transmits data over the TX line at the selected baud rate until the FIFO becomes empty.

The architecture is suitable for SoC-level integration, decoupling software writes from serial transmission timing.
