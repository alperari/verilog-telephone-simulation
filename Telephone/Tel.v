`timescale 1ns / 1ps

`timescale 1ns / 1ps



module tele(
    input clk,
    input rst,
	 
    input startCall,
    input answerCall,
	 
    input endCallCaller,
    input endCallCallee,
	 
    input sendCharCaller,
    input sendCharCallee,
	 
    input [7:0] charSent,
	 
    output reg [63:0] statusMsg,
    output reg [63:0] sentMsg,
	 output reg [31:0] cost
    );
	 
//STATES
parameter	IDLE 			= 3'b 000;
parameter	RINGING 		= 3'b 001;
parameter	REJECTED 	= 3'b 010;
parameter	CALLER_SEND = 3'b 011;
parameter	CALLEE_SEND = 3'b 100;
parameter	COST 			= 3'b 101;
							
				
reg [2:0] current_state = IDLE;							
reg [2:0] next_state = IDLE;

reg counter_enable = 0;
reg [5:0] counter = 0;

reg [1:0] constant = 0;
reg msg_enabler = 0;


//async rst = set the current state to idle
always @(posedge clk or posedge rst)
begin
	if(rst)
		current_state <= IDLE;
	else
		current_state <= next_state;
end



//Counter
always @(posedge clk)
begin
	if(counter_enable)
		counter <= counter + 1;
	else
		counter <= 0;
end

							
// State Transitions
always @*
begin
	case(current_state)
	
	IDLE:
	begin
		counter_enable = 0;
		if(startCall)
			next_state = RINGING;
		else 
			next_state = IDLE;
	end
	
	
	RINGING:
	begin
		counter_enable = 1;
		if(endCallCaller | counter == 9)
		begin
			next_state = IDLE;
			counter_enable = 0;
		end
		
		else if(endCallCallee)
		begin
			next_state = REJECTED;
			counter_enable = 0;
		end
		
		else if(answerCall)
		begin
			next_state = CALLER_SEND;
			counter_enable = 0;
		end	
		else
		begin
			next_state = RINGING;
		end
	end
	
	REJECTED:
	begin
		counter_enable = 1;
		if(counter == 9)
			next_state = IDLE;
		else 
			next_state = REJECTED;
	end
	
	
	CALLER_SEND:
	begin
		if(endCallCallee | endCallCaller)
			next_state = COST;
			
		else if(sendCharCaller & charSent == 8'd127)
			next_state = CALLEE_SEND;
			
		else
			next_state = CALLER_SEND;
	end
	
	CALLEE_SEND:
	begin
		counter_enable = 0;
		if(endCallCallee | endCallCaller)
			next_state = COST;
			
		else if(sendCharCallee & charSent == 8'd127)
			next_state = CALLER_SEND;
			
		else
			next_state = CALLEE_SEND;
	
	end
	
	COST:
	begin
		counter_enable = 1;
		if(counter == 4)
		begin
			next_state = IDLE;
			counter_enable = 0;
		end

		else 
			next_state = COST;
			
	end
	
	default:
	begin
		counter_enable = 0;
		next_state = IDLE;
	end
	endcase
end

// States Outputs
always @*
begin
	constant = 0;

	case(current_state)
	IDLE:
	begin
		statusMsg = "IDLE    ";
		msg_enabler = 0;
	end
	
	RINGING:
	begin
		statusMsg = "RINGING ";
				msg_enabler = 0;

	end
	
	REJECTED:
	begin
		statusMsg = "REJECTED";
		msg_enabler = 0;

	end
	

	CALLER_SEND:
	begin
		statusMsg = "CALLER  ";
		msg_enabler = 0;
		
		if(sendCharCaller)
		begin
			if((charSent >= 8'd48) & (charSent <= 8'd57))
				constant = 1;
			else if(((charSent >= 8'd32) & (charSent <= 8'd47)) | ((charSent >= 8'd58) & (charSent <= 8'd127)))
				constant = 2;
			else 
				constant = 0;
		end
		
		else
		begin
			constant = 0;
		end
		
	end
	
	CALLEE_SEND:
	begin
		statusMsg = "CALLEE  ";
		msg_enabler = 0;
		
		if(sendCharCallee)
		begin
			if((charSent >= 8'd48) & (charSent <= 8'd57))
				constant = 1;
			else if(((charSent >= 8'd32) & (charSent <= 8'd47)) | ((charSent >= 8'd58) & (charSent <= 8'd127)))
				constant = 2;
			else 
				constant = 0;
		end
		
		else
		begin
			constant = 0;
		end
		
	end
	
	COST:
	begin
		statusMsg = "COST    ";
		
		
		msg_enabler = 1;

	end
	
	default:
	begin
		statusMsg = "IDLE    ";
		msg_enabler = 0;
	end
	
	endcase
end


//change of cost and sentMsg
always @(posedge clk or posedge rst)
begin
	if(rst)
	begin
		cost <= 0;
		sentMsg <= 0;
	end
	
	else
	begin
			if(msg_enabler == 0) begin
				cost <= cost + constant;
				if(constant ==1 | constant == 2)
					sentMsg <= {sentMsg[56-1:0], charSent};
				else
					sentMsg <= sentMsg;
			end
			else
			begin
			
				if ((cost & 8'h0F) < 10)
					sentMsg[7:0]   <=(cost & 8'h0F) +48;
				else
					sentMsg[7:0]   <=((cost & 8'h0F)  - 10) +65;
				
				if (((cost >> 4)  & 8'h0F) < 10)
					sentMsg[15:8]   <=((cost >> 4) & 8'h0F) +48;
				else
					sentMsg[15:8]   <=(((cost >> 4) & 8'h0F)  - 10) +65;
					
				if (((cost >> 8)  & 8'h0F) < 10)
					sentMsg[23:16]   <=((cost >> 8) & 8'h0F) +48;
				else
					sentMsg[23:16]   <=(((cost >> 8) & 8'h0F)  - 10) +65;
				
				if (((cost >> 12)  & 8'h0F) < 10)
					sentMsg[31:24]   <=((cost >> 12) & 8'h0F) +48;
				else
					sentMsg[31:24]   <=(((cost >> 12) & 8'h0F)  - 10) +65;
				
				if (((cost >> 16)  & 8'h0F) < 10)
					sentMsg[39:32]   <=((cost >> 16) & 8'h0F) +48;
				else
					sentMsg[39:32]   <=(((cost >> 16) & 8'h0F)  - 10) +65;
					
				if (((cost >> 20)  & 8'h0F) < 10)
					sentMsg[47:40]   <=((cost >> 20) & 8'h0F) +48;
				else
					sentMsg[47:40]   <=(((cost >> 20) & 8'h0F)  - 10) +65;
					
				if (((cost >> 24)  & 8'h0F) < 10)
					sentMsg[55:48]   <=((cost >> 24) & 8'h0F) +48;
				else
					sentMsg[55:48]   <=(((cost >> 24) & 8'h0F)  - 10) +65;
					
				if (((cost >> 28)  & 8'h0F) < 10)
					sentMsg[63:56]   <=((cost >> 28) & 8'h0F) +48;
				else
					sentMsg[63:56]   <=(((cost >> 28) & 8'h0F)  - 10) +65;
				
		
			
			end
	end
	
end



endmodule
