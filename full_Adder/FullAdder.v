`timescale 1ns / 1ps

module FullAdder( carryin, x3, x2, x1, x0, y3, y2, y1, y0, s3, s2, s1, s0, carryout );
  
    input carryin, x3, x2, x1, x0, y3, y2, y1, y0;
    output s3, s2, s1, s0, carryout;
    wire c0, c1, c2, c3, c4, c5, c6, c7;
    assign carryin = 0;
    
    fullAdder stage0 ( c0, x0, y0, s0, c1 );
    fullAdder stage1 ( c1, x1, y1, s1, c2 );
    fullAdder stage2 ( c2, x2, y2, s2, c3 );
    fullAdder stage3 ( c3, x3, y3, s3, c4 );
    fullAdder stage4 ( c4, x4, y4, s4, c5 );
    fullAdder stage5 ( c5, x5, y5, s5, c6 );
    fullAdder stage6 ( c6, x6, y6, s6, c7 );
    fullAdder stage7 ( c7, x7, y7, s7, carryout );
    
endmodule

module fullAdder( Cin, X, Y, S, Cout );
  
    input Cin, X, Y;
    output S, Cout;
    assign S = X ^ Y ^ Cin;
    assign Cout = ( X & Y ) | ( X & Cin ) | ( Y & Cin );
    
endmodule


