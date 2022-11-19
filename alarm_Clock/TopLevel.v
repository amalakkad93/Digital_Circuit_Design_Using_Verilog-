`timescale 1ns / 1ps


module TopLevel(Alarm_switch, Alarm_Value_Sec, Alarm_Value_Min, Clk, AN, Out, DP, Alarm_status, audioOut, aud_sd, LED, LED1);
	input Clk, Alarm_switch;
	input [5:0] Alarm_Value_Sec, Alarm_Value_Min;
	output [7:0] AN;
	output [6:0] Out;
	output DP, Alarm_status, audioOut, aud_sd;
	wire OS1, OS2;
	wire [2:0] e;
	wire x, y, alarm_out, sound_playing, play_music, Q;
	wire [6:0] min, min0, min1, min2, sec, sec1, sec2;
	wire [6:0] Alarm_Value_Sec2, Alarm_Value_Min2;
	wire [6:0] Alarm_Value_Sec0, Alarm_Value_Sec1, Alarm_Value_Min0, Alarm_Value_Min1;
	output LED, LED1;
	
	assign Alarm_status = Alarm_switch;
	assign y = 0;
	assign LED1 = sound_playing;
	assign LED = play_music;
	
	ClkGen stage0 (Clk, OS1, OS2);
	TwoBitCounter stage1 (OS2, e);
	TwoToFour stage2 (e, AN);
	SixBinCount stage3 (OS1, sec, min);
	SixBinCount stage4 (min, min0, x);
	DisplayDecoder stage5 (sec, sec1, sec2);
	DisplayDecoder stage6 (min0, min1, min2);
	DisplayDecoder stage7 (Alarm_Value_Sec2, Alarm_Value_Sec0, Alarm_Value_Sec1);
	DisplayDecoder stage8 (Alarm_Value_Min2, Alarm_Value_Min0, Alarm_Value_Min1);
	MUX stage9 (sec1, sec2, min1, min2, e, Alarm_Value_Sec0, Alarm_Value_Sec1, Alarm_Value_Min0, Alarm_Value_Min1, Out, DP);
	Alarm_Count stage10 (OS1, Alarm_Value_Sec2, Alarm_Value_Min2, sec, min0, alarm_out);
	Alarm_Logic stage11 (Alarm_switch, alarm_out, Q, play_music);
	AlarmValue stage12 (Alarm_Value_Sec, Alarm_Value_Min, Alarm_Value_Sec2, Alarm_Value_Min2);
	SongPlayer stage13 (Clk, y, play_music, audioOut, aud_sd, sound_playing);
	DFF stage14 (sound_playing, OS1, Q);
	
endmodule

module ClkGen(clk, outsignal, outsignal2);
input clk;
	output reg outsignal, outsignal2;
	reg [26:0] counter;
	always @ (posedge clk)
	begin
	counter <= counter +1;
	if (counter % 125_000 == 0)
    	begin
        	outsignal2 <= ~outsignal2;
    	end
	
	if (counter == 50_000_000)
	begin
	outsignal <= ~outsignal;
	counter <= 0;
	end
	end
endmodule



module TwoBitCounter(Clock, Q);
 input Clock;
 output reg [2:0] Q;
 
 always @(posedge Clock)
   Q <= Q + 1;
endmodule


module TwoToFour(in, out);
	input [2:0] in;
	output reg [7:0] out;
	
	always@(in)
	begin
    	out = 8'b11111111;
    	case(in)
        	3'b000: out[0] = 0;
        	3'b001: out[1] = 0;
        	3'b010: out[2] = 0;
        	3'b011: out[3] = 0;
        	3'b100: out[4] = 0;
        	3'b101: out[5] = 0;
        	3'b110: out[6] = 0;
        	3'b111: out[7] = 0;
    	endcase
	end
endmodule



module SixBinCount(Clk, out, min);
	input Clk;
	output reg [5:0] out;
	output reg min;
	
	initial out = 0;
initial min = 0;
always @(posedge Clk)
begin
	out <= out + 1;
	
	if (out == 59)
	begin
    		min <= 1;
    		out <= 0;
	end
	else if (out == 0)
	begin
    		min <= 0;
	end 
end
endmodule



module SixBinCount(Clk, out, min);
	input Clk;
	output reg [5:0] out;
	output reg min;
	
	initial out = 0;
initial min = 0;
always @(posedge Clk)
begin
	out <= out + 1;
	
	if (out == 59)
	begin
    		min <= 1;
    		out <= 0;
	end
	else if (out == 0)
	begin
    		min <= 0;
	end 
end
endmodule




module DisplayDecoder(in, out, out2);
	input [5:0] in;
	output reg [6:0] out, out2;
	reg [3:0] x, y; //x = ones y = tens
	
	always@(in)
    	begin
        	x = in % 10; // find ones place
        	y = in / 10; //find tens place
        	out = 0;
        	case(x)
            	4'b0000: out = 7'b0000001; //0 in sev. seg.
            	4'b0001: out = 7'b1001111; //1
            	4'b0010: out = 7'b0010010; //2
            	4'b0011: out = 7'b0000110; //3
            	4'b0100: out = 7'b1001100; //4
            	4'b0101: out = 7'b0100100; //5
            	4'b0110: out = 7'b0100000; //6
            	4'b0111: out = 7'b0001111; //7
            	4'b1000: out = 7'b0000000; //8
            	4'b1001: out = 7'b0000100; //9
        	endcase
        	
        	out2 = 0;
        	case(y)
            	4'b0000: out2 = 7'b0000001;
            	4'b0001: out2 = 7'b1001111;
            	4'b0010: out2 = 7'b0010010;
            	4'b0011: out2 = 7'b0000110;
            	4'b0100: out2 = 7'b1001100;
            	4'b0101: out2 = 7'b0100100;
            	4'b0110: out2 = 7'b0000001;
            	default: out2 = 7'b0000001;
        	endcase
    	end
    	endmodule
    	
    	
module DisplayDecoder(in, out, out2);
	input [5:0] in;
	output reg [6:0] out, out2;
	reg [3:0] x, y; //x = ones y = tens
	
	always@(in)
    	begin
        	x = in % 10; // find ones place
        	y = in / 10; //find tens place
        	out = 0;
        	case(x)
            	4'b0000: out = 7'b0000001; //0 in sev. seg.
            	4'b0001: out = 7'b1001111; //1
            	4'b0010: out = 7'b0010010; //2
            	4'b0011: out = 7'b0000110; //3
            	4'b0100: out = 7'b1001100; //4
            	4'b0101: out = 7'b0100100; //5
            	4'b0110: out = 7'b0100000; //6
            	4'b0111: out = 7'b0001111; //7
            	4'b1000: out = 7'b0000000; //8
            	4'b1001: out = 7'b0000100; //9
        	endcase
        	
        	out2 = 0;
        	case(y)
            	4'b0000: out2 = 7'b0000001;
            	4'b0001: out2 = 7'b1001111;
            	4'b0010: out2 = 7'b0010010;
            	4'b0011: out2 = 7'b0000110;
            	4'b0100: out2 = 7'b1001100;
            	4'b0101: out2 = 7'b0100100;
            	4'b0110: out2 = 7'b0000001;
            	default: out2 = 7'b0000001;
        	endcase
    	end
endmodule

module DisplayDecoder(in, out, out2);
	input [5:0] in;
	output reg [6:0] out, out2;
	reg [3:0] x, y; //x = ones y = tens
	
	always@(in)
    	begin
        	x = in % 10; // find ones place
        	y = in / 10; //find tens place
        	out = 0;
        	case(x)
            	4'b0000: out = 7'b0000001; //0 in sev. seg.
            	4'b0001: out = 7'b1001111; //1
            	4'b0010: out = 7'b0010010; //2
            	4'b0011: out = 7'b0000110; //3
            	4'b0100: out = 7'b1001100; //4
            	4'b0101: out = 7'b0100100; //5
            	4'b0110: out = 7'b0100000; //6
            	4'b0111: out = 7'b0001111; //7
            	4'b1000: out = 7'b0000000; //8
            	4'b1001: out = 7'b0000100; //9
        	endcase
        	
        	out2 = 0;
        	case(y)
            	4'b0000: out2 = 7'b0000001;
            	4'b0001: out2 = 7'b1001111;
            	4'b0010: out2 = 7'b0010010;
            	4'b0011: out2 = 7'b0000110;
            	4'b0100: out2 = 7'b1001100;
            	4'b0101: out2 = 7'b0100100;
            	4'b0110: out2 = 7'b0000001;
            	default: out2 = 7'b0000001;
        	endcase
    	end
    	endmodule
    	
    	
module DisplayDecoder(in, out, out2);
	input [5:0] in;
	output reg [6:0] out, out2;
	reg [3:0] x, y; //x = ones y = tens
	
	always@(in)
    	begin
        	x = in % 10; // find ones place
        	y = in / 10; //find tens place
        	out = 0;
        	case(x)
            	4'b0000: out = 7'b0000001; //0 in sev. seg.
            	4'b0001: out = 7'b1001111; //1
            	4'b0010: out = 7'b0010010; //2
            	4'b0011: out = 7'b0000110; //3
            	4'b0100: out = 7'b1001100; //4
            	4'b0101: out = 7'b0100100; //5
            	4'b0110: out = 7'b0100000; //6
            	4'b0111: out = 7'b0001111; //7
            	4'b1000: out = 7'b0000000; //8
            	4'b1001: out = 7'b0000100; //9
        	endcase
        	
        	out2 = 0;
        	case(y)
            	4'b0000: out2 = 7'b0000001;
            	4'b0001: out2 = 7'b1001111;
            	4'b0010: out2 = 7'b0010010;
            	4'b0011: out2 = 7'b0000110;
            	4'b0100: out2 = 7'b1001100;
            	4'b0101: out2 = 7'b0100100;
            	4'b0110: out2 = 7'b0000001;
            	default: out2 = 7'b0000001;
        	endcase
    	end
endmodule

module MUX(in1, in2, in3, in4, s, in5, in6, in7, in8, out, DP);
	input [6:0] in1, in2, in3, in4, in5, in6, in7, in8;
	input [2:0] s;
	output reg [6:0] out;
	output reg DP;
	always@(*)begin
	DP = 1;
    	case(s)
    	3'b000: out = in1;
    	3'b001: out = in2;
    	3'b010: begin out = in3; DP = 0; end
    	3'b011: out = in4;
    	3'b100: out = in5;
    	3'b101: out = in6;
    	3'b110: begin out = in7; DP = 0; end
    	3'b111: out = in8;
    	endcase
	end
endmodule

module Alarm_Count(Clk, Alarm_Value_Sec, Alarm_Value_Min, Sec_Count, Min_Count, out);
    input Clk;
	input [6:0] Alarm_Value_Sec, Alarm_Value_Min, Sec_Count, Min_Count;
	reg next;
	output reg out;
	
always @(posedge Clk)
    begin
    out = 0;
	if ((Alarm_Value_Sec == Sec_Count) & (Alarm_Value_Min == Min_Count))
	begin
	   out = 1;
	end
end
endmodule


module Alarm_Logic(status, in, sound_playing, out);
input status, in, sound_playing;
output reg out;

always@*
    out = status & (in + sound_playing);

endmodule

module AlarmValue(in_sec, in_min, out_sec, out_min);
input [5:0] in_sec, in_min;
output reg [5:0] out_sec, out_min;



always@*
begin
if(in_sec > 59 & in_min > 59)
begin
    out_sec = 59;
    out_min = 59;
end
else if(in_sec > 59)
begin
    out_sec = 59;
    out_min = in_min;
end
else if(in_min > 59)
begin
    out_sec = in_sec;
    out_min = 59;
end
else 
begin
    out_sec = in_sec;
    out_min = in_min;
end
end
endmodule

module SongPlayer( input clock, input reset, input playSound, output reg audioOut, output wire aud_sd, output reg playing);
reg [19:0] counter;
reg [31:0] time1, noteTime;
reg [9:0] msec, number; //millisecond counter, and sequence number of musical note.
wire [4:0] note, duration;
wire [19:0] notePeriod;
parameter clockFrequency = 100_000_000;
assign aud_sd = 1'b1;
MusicSheet  mysong(number, notePeriod, duration );
always @ (posedge clock)
  begin
    if(reset | ~playSound)
    begin
        playing <= 0;
      	counter <=0; 
      	time1<=0; 
      	number <=0; 
      	audioOut <=1; 
    end
    else
    begin
        counter <= counter + 1;
        time1<= time1+1;
        if( counter >= notePeriod)
            begin
            counter <=0; 
            audioOut <= ~audioOut ;
            end //toggle audio output  
        if( time1 >= noteTime)
            begin 
            time1 <=0; 
            number <= number + 1;
            end  //play next note
        if(number == 99) number <=0; // Make the number reset at a set amount (max 99)
        playing = 1;
    end
 end 
     	
  always @(duration) noteTime = duration * clockFrequency / 16;
   	//number of   FPGA clock periods in one note.
endmodule


module MusicSheet( input [9:0] number,
 output reg [19:0] note,//max 32 different musical notes
 output reg [4:0] duration);
parameter   QUARTER = 5'b00010;//2 Hz
parameter HALF = 5'b00100;
parameter ONE = 2* HALF;
parameter TWO = 2* ONE;
parameter FOUR = 2* TWO;
parameter   E3 = 135151, F3 = 127561, G3 = 120398, A4 = 113636, B4 = 107254, C4=95557, D4=85131, E4 = 75844, F4=71586, G4 = 63776, C5 = 47801, SP = 1; 
 
always @ (number) begin
case(number) //Row Row Row your boat
0:  	begin note = G3;  duration = QUARTER; end //row
1:   begin note = SP; duration = QUARTER;  end //
2:   begin note = F3; duration = QUARTER;  end //row
3:   begin note = SP;  duration = QUARTER; end //
4:   begin note = F3; duration = QUARTER;  end //row
5:   begin note = SP; duration = HALF;  end //
6:   begin note = F3; duration = QUARTER;  end //your
7:   begin note = SP; duration = QUARTER;  end //
8:  	begin note = E3; duration = QUARTER;  end //
9:  	begin note = SP; duration = QUARTER;  end //
10:  begin note = E3; duration = QUARTER;  end //
11:  begin note = SP; duration = HALF;  end //down
12:  begin note = A4; duration = QUARTER;  end //
13:  begin note = SP; duration = QUARTER; end //
14:  begin note = A4; duration = QUARTER;  end //the
15:  begin note = SP; duration = QUARTER;  end //stream
16:  begin note = G3; duration = QUARTER; end //
17:  begin note = SP; duration = QUARTER;  end //merrily
18:  begin note = B4; duration = QUARTER;  end //
19:  begin note = SP; duration = HALF;  end //
20:  begin note = B4; duration = QUARTER;  end //
21:  begin note = SP; duration = QUARTER;  end //
22:  begin note = B4; duration = QUARTER;  end //
23:  begin note = SP; duration = QUARTER;  end //
24:  begin note = B4; duration = QUARTER;  end //
25:  begin note = SP; duration = QUARTER;  end //
26:  begin note = B4; duration = QUARTER;  end //
27:  begin note = SP; duration = QUARTER;  end //
28:  begin note = B4; duration = QUARTER;  end //
29:  begin note = SP; duration = QUARTER;  end //
30:  begin note = A4; duration = QUARTER;  end //
31:  begin note = SP; duration = QUARTER;  end //
32:  begin note = C4; duration = QUARTER;  end //
33:  begin note = SP; duration = HALF;  end //
34:  begin note = E4; duration = QUARTER;  end //
35:  begin note = SP; duration = QUARTER;  end //
36:  begin note = E4; duration = QUARTER;  end //
37:  begin note = SP; duration = HALF;  end //
38:  begin note = E4; duration = QUARTER;  end //
39:  begin note = SP; duration = QUARTER;  end //
40:  begin note = D4; duration = QUARTER;  end //
41:  begin note = SP; duration = QUARTER;  end //Life
42:  begin note = D4; duration = QUARTER;  end //
43:  begin note = SP; duration = HALF;  end //is
44:  begin note = F3; duration = QUARTER;  end //but
45:  begin note = SP; duration = QUARTER;  end //
46:  begin note = F3; duration = QUARTER;  end //
47:  begin note = SP; duration = QUARTER;  end //
48:  begin note = G3; duration = QUARTER;  end //
49:  begin note = SP; duration = QUARTER;  end //
50:  begin note = G3; duration = QUARTER;  end //
51:  begin note = SP; duration = HALF;  end //
52:  begin note = G3; duration = QUARTER;  end //
53:  begin note = SP; duration = QUARTER;  end //
54:  begin note = G3; duration = QUARTER;  end //
55:  begin note = SP; duration = QUARTER;  end //
56:  begin note = E4; duration = QUARTER;  end //
57:  begin note = SP; duration = QUARTER;  end //
58:  begin note = D4; duration = QUARTER;  end //
59:  begin note = SP; duration = QUARTER;  end //
60:  begin note = D4; duration = QUARTER;  end //
61:  begin note = SP; duration = QUARTER;  end //
62:  begin note = D4; duration = QUARTER;  end //
63:  begin note = SP; duration = QUARTER;  end //
64:  begin note = C4; duration = QUARTER;  end //
65:  begin note = SP; duration = QUARTER;  end //
66:  begin note = C4; duration = QUARTER;  end //
67:  begin note = SP; duration = HALF;  end //
68:  begin note = A4; duration = QUARTER;  end //
69:  begin note = SP; duration = QUARTER;  end //
70:  begin note = A4; duration = QUARTER;  end //
71:  begin note = SP; duration = QUARTER;  end //
72:  begin note = A4; duration = QUARTER;  end //
73:  begin note = SP; duration = QUARTER;  end //
74:  begin note = B4; duration = QUARTER;  end //
75:  begin note = SP; duration = QUARTER;  end //
76:  begin note = B4; duration = QUARTER;  end //
77:  begin note = SP; duration = QUARTER;  end //
78:  begin note = B4; duration = QUARTER;  end //
79:  begin note = SP; duration = QUARTER;  end //
80:  begin note = B4; duration = QUARTER;  end //
81:  begin note = SP; duration = QUARTER;  end //
82:  begin note = C4; duration = QUARTER;  end //
83:  begin note = SP; duration = QUARTER;  end //
84:  begin note = C4; duration = QUARTER;  end //
85:  begin note = SP; duration = QUARTER;  end //
86:  begin note = C4; duration = QUARTER;  end //
87:  begin note = SP; duration = QUARTER;  end //
88:  begin note = C4; duration = QUARTER;  end //
89:  begin note = SP; duration = QUARTER;  end //
90:  begin note = C4; duration = QUARTER;  end //
91:  begin note = SP; duration = QUARTER;  end //
92:  begin note = A4; duration = QUARTER;  end //
93:  begin note = SP; duration = QUARTER;  end //
94:  begin note = A4; duration = QUARTER;  end //
95:  begin note = SP; duration = QUARTER;  end //
96:  begin note = A4; duration = QUARTER;  end //
97:  begin note = SP; duration = QUARTER;  end //
98:  begin note = A4; duration = QUARTER;  end //
default:  begin note = C4; duration = FOUR;  end
endcase
end
endmodule

module DFF (D, Clock, Q); 
	input D, Clock; 
	output reg Q;
	reg [5:0] count;
	parameter TIME = 10;
	
	always @(posedge Clock)
	begin
		Q = D;
		if(count < TIME)
		  count = count + 1;
		else
		begin
		  Q = 0;
		  count = 0;
		end
	end
	
endmodule

