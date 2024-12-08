module aludec(
    opcode,
    funct3,
    funct7,
    ALUop,
    ALUControl
);
    // input
    input [6:0] opcode;
    input [2:0] funct3;
    input [1:0] ALUop;
    input funct7;
     // output
    output reg [4:0] ALUControl;

always@(*)begin                // ALU decoder
        if (ALUop == 2'b00) begin
                ALUControl = 5'b0_0000;
        end
        else if (ALUop == 2'b01) begin           
                if (funct3 == 3'b111) // bgeu
                    ALUControl = 5'b1_0001;
                else if (funct3 == 3'b110) // bltu
                    ALUControl = 5'b1_0010;
                else 
                    ALUControl = 5'b1_0000;        
        end

        else if (ALUop == 2'b10) begin
                if (funct3 == 3'b000 && ({opcode[5], funct7} == 2'b00 || {opcode[5], funct7} == 2'b01 || {opcode[5], funct7} == 2'b10))                                             
                    ALUControl = 5'b0_0000; // add
                else if (funct3 == 3'b000 && funct7 == 1'b1)	
                    ALUControl = 5'b1_0000; // sub
                else if (funct3 == 3'b100)
                    ALUControl = 5'b0_0011; // xor
                else if (funct3 == 3'b001)                     
                    ALUControl = 5'b0_0100; // sll
                else if (funct3 == 3'b101 && funct7 == 1'b0)
                    ALUControl = 5'b0_0101; // srl  
                else if (funct3 == 3'b101 && funct7 == 1'b1) 
                    ALUControl = 5'b0_0110; // sra      
                else if (funct3 == 3'b010)
                    ALUControl = 5'b1_0111; // slt
                else if (funct3 == 3'b011)
                    ALUControl = 5'b1_1000; // sltu        
                else if (funct3 == 3'b110)
                    ALUControl = 5'b0_0010; // or
                else if (funct3 == 3'b111)
                    ALUControl = 5'b0_0001; // and
                else if (funct3 == 3'b001 && funct7 == 1'b0)    
                    ALUControl = 5'b0_0100; // slli
                else 
                    ALUControl = 5'hx;     
        end        
        else begin
            ALUControl = 5'hx;
        end
    end

endmodule
