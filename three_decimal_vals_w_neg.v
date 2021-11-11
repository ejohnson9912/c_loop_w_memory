module three_decimal_vals_w_neg (
input [7:0]val,
output [6:0]seg7_neg_sign,
output [6:0]seg7_hundreds,
output [6:0]seg7_tens,
output [6:0]seg7_ones
);
 
reg res_neg;
reg [3:0]res_hundreds;
reg [3:0]res_tens;
reg [3:0]res_ones;
 
reg [7:0]twos_comp;
 
always @(*)
begin
 
if (val[7] == 1'b1)
begin
res_neg = 1'b1;
twos_comp = ~(val) + 1'b1;
res_hundreds = twos_comp / 8'd100;
res_tens = (twos_comp / 8'd10) % 8'd10;
res_ones = twos_comp % 8'd10;
end
else
begin
res_neg = 1'b0;
twos_comp = val;
res_hundreds = twos_comp / 8'd100;
res_tens = (twos_comp / 8'd10) % 8'd10;
res_ones = twos_comp % 8'd10;
end
end
 
seven_segment_negative neg(res_neg, seg7_neg_sign);
seven_segment hundreds(res_hundreds, seg7_hundreds);
seven_segment tens(res_tens, seg7_tens);
seven_segment ones(res_ones, seg7_ones);
 
endmodule