module c_loop_w_memory (
input clk, 
input rst, 
input go,
input displayControl, // 00 = sum, 01 = my i variable
output reg done,
output [6:0]HEX3,
output [6:0]HEX2,
output [6:0]HEX1,
output [6:0]HEX0
);

reg [24:0]counter;
reg clk_out;
reg [7:0]disp_val;
wire [6:0]num_out;

/* memory signals
module numbers (
	address,
	clock,
	data,
	wren,
	q);

	input	[4:0]  address;
	input	  clock;
	input	[7:0]  data;
	input	  wren;
	output	[7:0]  q; */
numbers memory(
	i, // 0 to 9
	clk,
	8'd0,
	1'b0,
	num_out);
	

/* Seven seg signals */


/* FSM signals and parameters */
reg [3:0] S;
reg [3:0] NS;

// reg [20:0] delay;

parameter PROG = 4'd0,
          START = 4'd1,
			 FORINIT = 4'd2,
			 COND = 4'd3,
			 SUM = 4'd4,
			 INCR = 4'd5,
			 EXIT = 4'd6,
			 ERROR = 4'hF;

/* sum and i variables */
reg [4:0] i;
reg [6:0] sum;	

reg [7:0] numbers[9:0];




/* instantiate IP memory for the array of numbers */

		
/* S update always block */
always @(posedge clk or negedge rst) 
begin
	if (rst == 1'b0) begin
		counter = 25'b0;
		clk_out = 1'b0;
	end else begin
		counter = counter + 25'd1;
	if (counter == 25'd25_000_000) begin
		counter = 25'd0;
		clk_out = ~clk_out;
	end
end
end

always @(posedge clk_out or negedge rst) begin
    if (rst == 1'b0) begin
	     S <= PROG;
	 end else begin 
	     S = NS;
	end
end


always @(*) begin 
    
    case(S) 
	      PROG: begin 
		       if (go == 1'd0) begin
				     NS = PROG;
				 end else begin
				     NS = START;
				end
	      end START: begin
			    NS = FORINIT;
			end FORINIT : begin
				 NS = COND;
			end COND: begin
			    if (i < 5'd10) begin
				     
				     NS = SUM;
				 end else begin
				     NS = EXIT;
				 end
				 
			end  SUM: begin
			      NS = INCR;
			end INCR: begin
			      NS = COND;
			 end  EXIT : begin
			       NS = EXIT;
			end default: 
			       NS = ERROR;
	   endcase
end
	 


/* clocked control signals always block */
always @(posedge clk_out or negedge rst) 
begin
	   if (rst == 1'b0) begin
		   sum <= 7'd0;
			i <= 5'd0;
		end  else begin
		case (S)
		   PROG : begin
			end
			START: begin
			    sum <= 7'd00;
				 i <= 5'd0;
			end FORINIT : begin
			    i <= 5'd00;
			end COND: begin
			    
		   end SUM: begin
			     sum <= sum + num_out;
			end  INCR: begin
			     i <= i + 5'd1;
				
			
			end EXIT : begin
			end default : begin
			    sum <= (7'd5);
			end
		endcase
		end
		
	
end


		
always @(*)
begin
	/* Mux for display on seven segs */
	case (displayControl)
	    1'b0: disp_val = sum;
		 1'b1: disp_val = i;
		 default: disp_val = sum;
	endcase
end

/* instantiate the module to display the 8 bit result */
three_decimal_vals_w_neg two_d(disp_val, HEX3, HEX2, HEX1, HEX0);

endmodule 