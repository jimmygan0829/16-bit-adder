module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
     
logic c4, c8, c12;  //divide 16 bits into 4 groups, cout from last group determine next cin, select from two pre-calculated cout
four_bit_ra FBA0(.x(A[3:0]),.y(B[3:0]),.cin(0),.s(Sum[3:0]),.cout(c4)); //the first four bits using ripple adder
carryselect SA1 (.x(A[7:4]),.y(B[7:4]),.cin(c4),.s(Sum[7:4]),.cout(c8)); //then the following groups using carry select adderj
carryselect SA2 (.x(A[11:8]),.y(B[11:8]),.cin(c8),.s(Sum[11:8]),.cout(c12)); 
carryselect SA3 (.x(A[15:12]),.y(B[15:12]),.cin(c12),.s(Sum[15:12]),.cout(CO)); 
    
endmodule



module carryselect //adding 4 bits with selected carry in
(
    input [3:0] x,
    input [3:0] y,
    input cin,
    output logic cout,
    output logic [3:0]s

);
    logic [3:0] s0; //numbers added when carry in = 0
    logic [3:0] s1; //numbers added when carry in = 1
    logic cout_0; 
    logic cout_1; 

    four_bit_ra FBA0(.x(x[3:0]),.y(y[3:0]),.cin(0),.s(s0[3:0]),.cout(cout_0)); 
    four_bit_ra FBA1(.x(x[3:0]),.y(y[3:0]),.cin(1),.s(s1[3:0]),.cout(cout_1)); 
    
    always_comb
    begin

    cout=cout_0|(cout_1&cin); //implement cout from figure 5 in the lab manual
	 
    if(cin==1)
        s[3:0]=s1[3:0]; //selecting when carry in = 1
    else
        s[3:0]=s0[3:0]; //selecting when carry in = 0
    end
    
	endmodule
	