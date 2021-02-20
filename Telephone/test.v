`timescale 1ns / 1ps

module  tel_tb();

// I-O port names
reg clk;
reg rst;
reg startCall,answerCall;
reg endCallCaller,endCallCallee;
reg sendCharCaller,sendCharCallee;
reg [7:0] charSent;
wire[63:0] statusMsg;
wire[63:0] sentMsg;
wire[31:0] cost;

// module instantiation
tele uut   (
			.clk(clk),
         .rst(rst),
		   .startCall(startCall),
			.answerCall(answerCall),
		   .endCallCaller(endCallCaller),
			.endCallCallee(endCallCallee),
		   .sendCharCaller(sendCharCaller),
			.sendCharCallee(sendCharCallee),
		   .charSent(charSent),
		   .statusMsg(statusMsg),
		   .sentMsg(sentMsg),
			.cost(cost)								);



// 100 MHz clock
always #5 clk = ~clk; 

initial begin
	// initialize every input to 0
	clk = 0;
	rst = 0;
	startCall = 0;
	answerCall = 0;
	endCallCaller = 0;
	endCallCallee = 0;
	sendCharCaller = 0;
	sendCharCallee = 0;
	charSent = " ";
	
	// Xilinx global reset time
	#100; 
	
	// reset your circuit
	rst=1; #20; rst=0; #20; rst=0;              // reset
	
	startCall=1; #10; startCall=0; #10;         // caller starts call
	#100;                                       // statusMsg displaying "RINGING " 
	                                            // no answer for 10 clock cycles (and go back to IDLE)
	#20;
	
	startCall=1; #10; startCall=0; #10;         // caller starts call
	#20;                                        // statusMsg displaying "RINGING " 
	endCallCaller=1; #10; endCallCaller=0; #10; // caller ends the call
	#20;                                        // statusMsg displaying "RINGING " 
	
	startCall=1; #10; startCall=0; #10;         // caller starts call
	#20;                                        // statusMsg displaying "RINGING " 
	endCallCallee=1; #10; endCallCallee=0; #10; // callee rejects the call
	#100;                                       // statusMsg displaying 'REJECTED' for 10 clock cycles
	#20;
	
	startCall=1; #10; startCall=0;              // caller starts call
	#20;                                        // statusMsg displaying "RINGING " 
	answerCall=1; #10; answerCall=0;            // callee answer call
	#20;                                        // statusMsg displaying "CALLER  " 
	
	sendCharCaller=1; charSent="T"; #10; sendCharCaller=0; #10; // caller sends "T", sentMsg displaying "       T", cost is 2 
	sendCharCaller=1; charSent="E"; #10; sendCharCaller=0; #10; // caller sends "E", sentMsg displaying "      TE", cost is 4 
	sendCharCaller=1; charSent="R"; #10; sendCharCaller=0; #10; // caller sends "R", sentMsg displaying "     TER", cost is 6 
	sendCharCaller=1; charSent="M"; #10; sendCharCaller=0; #10; // caller sends "M", sentMsg displaying "    TERM", cost is 8 
	sendCharCaller=1; charSent=" "; #10; sendCharCaller=0; #10; // caller sends " ", sentMsg displaying "   TERM ", cost is 10
	sendCharCaller=1; charSent= 12; #10; sendCharCaller=0; #10; // caller sends (invalid char), no change on sentMsg and cost
	sendCharCaller=1; charSent="P"; #10; sendCharCaller=0; #10; // caller sends "P", sentMsg displaying "  TERM P", cost is 12
	#10;
	#10;
	sendCharCaller=1; charSent="R"; #10; sendCharCaller=0; #10; // caller sends "R", sentMsg displaying " TERM PR", cost is 14
	sendCharCaller=1; charSent="O"; #10; sendCharCaller=0; #10; // caller sends "O", sentMsg displaying "TERM PR0", cost is 16
	sendCharCaller=1; charSent="J"; #10; sendCharCaller=0; #10; // caller sends "J", sentMsg displaying "ERM PR0J", cost is 18
	sendCharCaller=1; charSent="E"; #10; sendCharCaller=0; #10; // caller sends "E", sentMsg displaying "RM PR0JE", cost is 20
	sendCharCaller=1; charSent="C"; #10; sendCharCaller=0; #10; // caller sends "C", sentMsg displaying "M PR0JEC", cost is 22
	sendCharCaller=1; charSent="T"; #10; sendCharCaller=0; #10; // caller sends "T", sentMsg displaying " PROJECT", cost is 24
	#10;
	#10;
	sendCharCaller=1; charSent=127; #10; sendCharCaller=0; #10; // caller sends DEL to change turn, cost is 26
	#10;                                                        // statusMsg displaying "CALLEE  " 
	#10;
	sendCharCallee=1; charSent="C"; #10; sendCharCallee=0; #10; // callee sends "C", sentMsg displaying "       C", cost is 28 
	sendCharCallee=1; charSent="S"; #10; sendCharCallee=0; #10; // callee sends "S", sentMsg displaying "      CS", cost is 30 
	#10;
	sendCharCallee=1; charSent="3"; #10; sendCharCallee=0; #10; // callee sends "3", sentMsg displaying "     CS3", cost is 31
	sendCharCallee=1; charSent="0"; #10; sendCharCallee=0; #10; // callee sends "0", sentMsg displaying "    CS30", cost is 32
	sendCharCallee=1; charSent="3"; #10; sendCharCallee=0; #10; // callee sends "3", sentMsg displaying "   CS303", cost is 33
	#10;
	endCallCallee=1; #10; endCallCallee=0; // callee ends the call
	#50;	                               // statusMsg displaying "COST    ", sentMsg displaying "00000021"
end


endmodule
