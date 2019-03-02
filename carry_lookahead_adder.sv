module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    logic c4, c8, c12; //local variables for inputs/outputs of individual 4-bit lookahead adders
    logic Pg0, Pg1, Pg2, Pg3;
    logic Gg0, Gg1, Gg2, Gg3;
    
    fb_l_adder DLLM0(.a(A[3:0]),.b(B[3:0]),.Cin(0),.sum(Sum[3:0]),.Gg(Gg0),.Pg(Pg0));
	 //instantiate four 4-bit lookahead adders
	 
	 always_comb
	 
    begin
    c4 = (Gg0);
    end
  
	 
    fb_l_adder DLLM1(.a(A[7:4]),.b(B[7:4]),.Cin(c4),.sum(Sum[7:4]),.Gg(Gg1),.Pg(Pg1));
	 
	 always_comb
	 
    begin
    c8 = ((Pg1&Gg0) | Gg1);
    end
  
	
    fb_l_adder DLLM2(.a(A[11:8]),.b(B[11:8]),.Cin(c8),.sum(Sum[11:8]),.Gg(Gg2),.Pg(Pg2));
	 always_comb
	 
    begin
    c12 = ((Pg2&Pg1&Gg0) | Gg2|(Gg1&Pg2));
    end
  

	 
    fb_l_adder DLLM3(.a(A[15:12]),.b(B[15:12]),.Cin(c12),.sum(Sum[15:12]),.Gg(Gg3),.Pg(Pg3));
	 	 always_comb
	 
    begin
    CO = ((Pg3&Gg2) | Gg3 | (Pg3&Gg1&Pg2) | (Pg3&Gg0&Pg2&Pg1));
    end
  

	 
	 

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
     
endmodule

module l_adder //individual lookahead adder
(

    input x, 
    input y, 
    input cin,
    output logic s,
    output logic cout,
    output logic g, //generating
    output logic p //propagating
	 
);

    always_comb
	 
    begin
    //logic for basic full adder units
		p = x^y;
		s = x^y^cin;
		g = x&y;
   
    cout = (p&cin)|g;
    
    end
   endmodule

module fb_l_adder   //one block of the 4 bit
(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output logic [3:0] sum,
    output logic Gg, 
    output logic Pg 
);

    //local variables within one block of 4 bit unit
    logic g0, g1, g2, g3;
    logic p0, p1, p2, p3;
    logic c0,c1,c2,c3;
    l_adder DL0(.x(a[0]),.y(b[0]),.cin(Cin),.cout(c0),.s(sum[0]),.g(g0),.p(p0));  //activate four lookahead adders
    l_adder DL1(.x(a[1]),.y(b[1]),.cin(c0),.cout(c1),.s(sum[1]),.g(g1),.p(p1));
    l_adder DL2(.x(a[2]),.y(b[2]),.cin(c1),.cout(c2),.s(sum[2]),.g(g2),.p(p2));
    l_adder DL3(.x(a[3]),.y(b[3]),.cin(c2),.cout(c3),.s(sum[3]),.g(g3),.p(p3));
    
    always_comb
    begin 
    Gg = (g3|(g2&p3)|(g1&p2&p3)|(g0&p1&p2&p3));//calculating Gg and Pg
    Pg = (p0&p1&p2&p3);  
    
    
    end
    
endmodule
