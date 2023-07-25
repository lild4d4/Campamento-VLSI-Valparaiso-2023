`timescale 1ns / 1ps

/*
Universidad técnica Federico Santa María, Valparaíso
Autor: Patricio Henriquez
*/

module ALU_reg_ref#(
    parameter N = 16
) (

    input wire clk, reset, load_A, load_B, load_Op, updateRes,
    input wire [N-1 : 0] data_in,
    
    output reg [N-1:0] result,
    output reg [4:0] flags
);

    reg [N-1:0] A, B, Result_next;//, Result;
    reg [4:0] Status_next, Status;
    reg [1:0] OpCode;
    
    //assign display = Result;
    
    always @(posedge clk) begin 
        {A, B, OpCode, flags, result} <= {A, B, OpCode, flags, result};
        
        if(reset)
            {A, B, OpCode, flags, result} <= 'd0;
        else begin
            if(updateRes)
                {flags, result} <= {Status_next, Result_next}; 
            if(load_A)
                A <= data_in;
            if(load_B)
                B <= data_in;
            if(load_Op)
                OpCode <= data_in[1:0];
       end     
    end
    

    reg Neg, Z, C, V, P;
    
    always @(*) begin
		case(OpCode)
			2'd0: begin
                // NOR
				Result_next = ~(A | B);
				C = 1'b0;
				V = 1'b0;
			end

			2'd1: begin
                // NAND
				Result_next = ~(A & B);
				C = 1'b0;
				V = 1'b0;
			end

			2'd2: begin
                // SUMA
                {C, Result_next} = A + B;
				V = (Result_next[N-1] & ~A[N-1] & ~B[N-1]) | (~Result_next[N-1] & A[N-1] & B[N-1]);
			end

			2'd3: begin
                // RESTA
                {C, Result_next} = A - B;
				V = (Result_next[N-1] & ~A[N-1] & B[N-1]) | (~Result_next[N-1] & A[N-1] & ~B[N-1]);	
			end
		endcase

		Neg = Result_next[N-1];
		Z = (Result_next == '0);
        P = ~^Result_next;

		Status_next = {V, C, Z, Neg, P};
	end

endmodule
