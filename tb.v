`timescale 1 ps / 1 ps

module tb;

	reg[7:0] step_val;
	
	task sevenSeg(input [6:0] val);
	begin
		case (val)
			7'b0000001: $write("0");
			7'b1001111: $write("1");
			7'b0010010: $write("2");
			7'b0000110: $write("3");
			7'b1001100: $write("4");
			7'b0100100: $write("5");
			7'b0100000: $write("6");
			7'b0001111: $write("7");
			7'b0000000: $write("8");
			7'b0001100: $write("9");
			7'b0001000: $write("A");
			7'b1100000: $write("B");
			7'b0110001: $write("C");
			7'b1000011: $write("D");
			7'b0110000: $write("E");
			7'b0111000: $write("F");
			default: $write("seg:ERROR");
		endcase
	end
	endtask
	task sevenSegNeg		(input [6:0] val);
	begin
		case (val)
			7'b1111110: $write("-");
			7'b1111111: $write("+");
			default: $display("neg:ERROR");
		endcase
	end
	endtask
	task step();
	begin
		$write("%d: ", step_val);
		step_val = step_val + 1;
	end
	endtask

	
	parameter simdelay = 20; // guaranteed 2 clocks
	parameter clock_delay = 5;
	parameter fullclk = 11;
		
	reg clk;
	reg rst;
	reg start;
	reg [1:0] display_control;
	wire done;
	wire [6:0]seg7_dig2;
	wire [6:0]seg7_dig1;
	wire [6:0]seg7_dig0;
	wire [6:0]seg7_neg;
		
	c_loop_w_memory DUT(
			clk, 
			rst, 
			start,
			display_control, // 00 = sum, 01 = my i variable
			done,
			seg7_neg,
			seg7_dig0,
			seg7_dig1,
			seg7_dig2
			);
	
	initial
	begin
		
		/* start clk and reset */
		#(simdelay) rst = 1'b0; clk = 1'b0; step_val = 8'd0;
		#(simdelay) rst = 1'b1; /* go into normal circuit operation */ 
		
		/* start */ #(simdelay) start = 1'b1; display_control = 2'd0;
		end
	
	/* this checks done every clock and when it goes high ends the simulation */
	always @(clk)
	begin
		if (done == 1'b1)
		begin
			$write("DONE:"); sevenSegNeg(seg7_neg); sevenSeg(seg7_dig2); sevenSeg(seg7_dig1); sevenSeg(seg7_dig0); $write("\n"); 
			$stop;
		end
		else
		begin
			step(); sevenSegNeg(seg7_neg); sevenSeg(seg7_dig2); sevenSeg(seg7_dig1); sevenSeg(seg7_dig0); $write("\n"); 
		end
	end
	
		// this generates a clock
	always
	begin
		#(clock_delay) clk = !clk; 
	end
	
	//initial
	//	#(1000) $stop; // This stops the simulation ... May need to be greater or less depending on your program
	
endmodule
