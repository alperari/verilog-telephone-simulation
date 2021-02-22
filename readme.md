# Simple-Telephone-Conversation-VHDL-in-XILINX-
##### My verilog code for CS303 Term Project (Fall 2020)



In this project, I’ve designed a sequential circuit for a simple two-sided telephone conversation and implemented it using Verilog HDL



 Basically, the caller will initiate a telephone conversation with the callee and the caller will send characters to the callee (and vice versa). 



My circuit also calculates the cost of the call and sends the cost value and the characters (sent from the caller to callee and vice versa) as outputs.





#### Inputs 

###### There will be 8 inputs in circuitry: 

​	• **rst** will set your circuitry to its initial state. 

​	• **startCall** **(1-bit)** will be used by the caller and it will represent that the caller pressing a button to start a call. 

​	• **answerCall** **(1-bit)** will be used by the callee and it will represent that the callee pressing a button to answer an incoming call. 

​	• **callerEndsCall** **(1-bit)** will be used by the caller and it will represent that the caller pressing a button to end an ongoing/outgoing call. 

​	• **calleeEndsCall** **(1-bit)** will be used by the callee and it will represent that the callee pressing a button to end an ongoing/incoming call. 

​	• **charSent** **(8-bit)** will be used to define 8-bit printable ASCII character to be sent from the caller to the callee (and vice versa) according to printable ASCII table shown at Fig. 1. 

​	• **callerSendsChar** **(1-bit)** will be used by the caller and it will represent that the caller pressing a button to send an ASCII character (set by charSent input) to the callee. 

​	• **calleeSendsChar** **(1-bit)** will be used by the callee and it will represent that the callee pressing a button to send an ASCII character (set by charSent input) to the callee.





#### Outputs 

###### There will be 2 outputs in circuitry: 

• **statusMsg** **(64-bit)** will be used to display the status of telephone using 8 printable ASCII character. For example, **statusMsg** output should be **“IDLE “** in its initial state. More details will be provided below. 

• **sentMsg** **(64-bit)** will be used to display the last 8 printable ASCII characters sent by caller or callee. 

(**Cost** : additional output to check if it calculates the cost value properly)



#### States

###### I have 6 states which are labeled as:

1-   **S0 = IDLE**

2-   **S1 = RINGING**

3-   **S2 = REJECTED**

4-   **S3 = CALLER_SEND**

5-   **S4 = CALLE_SEND**

6-   **S5 = COST**

![a](https://user-images.githubusercontent.com/68128434/108763328-4f24f900-7562-11eb-983c-ceb831e89a70.jpg)

A sample simulation and waveform from project:

![b](https://user-images.githubusercontent.com/68128434/108763412-67951380-7562-11eb-9742-b9783fbd741f.jpg)





More information is available in PDF