module seven_segment(
input [3:0]i,
output reg [6:0]o
);


// HEX out - rewire DE2
//  ---a---
// |       |
// f       b
// |       |
//  ---g---
// |       |
// e       c
// |       |
//  ---d---

always @(*)
begin
	case (i)	    // abcdefg
         4'b0000:
				o = 7'b1000000;
			4'b0001:
				o = ~7'b0000110;
			4'b0010:
				o = ~7'b1011011;
			4'b0011:
				o = ~7'b1001111;
			4'b0100:
				o = ~7'b1100110;
			4'b0101:
				o = ~7'b1101101;
			
			4'b0110:
				o = 7'b0000010;
				
			4'b0111:
				o = 7'b1111000;
			4'b1000:
				o = 7'b0000000;
			4'b1001:
				o = 7'b0011000;
			
			4'b1010:
				o = 7'b1000000;
			
		   
			
			
			
			
			default: 
				o = 7'b1000000;
	endcase
end

endmodule