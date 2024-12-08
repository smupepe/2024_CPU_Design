module be_logic( // load, store
    w_d,
    r_d,
    addr_last2,
    funct3,
    be_wd,
    be_rd,
    byte_enable
);

    input [31:0] w_d, r_d;
    input [1:0] addr_last2;
    input [2:0] funct3;

    output reg [31:0] be_wd, be_rd;
    output reg [3:0] byte_enable;

    always @(*) begin
        case (funct3)
            3'b000 : begin // signed byte
                case (addr_last2)
                    2'b00 : begin
                        be_rd = {{24{r_d[7]}}, r_d[7:0]};
                        be_wd = {{24'b0}, w_d[7:0]};
                        byte_enable = 4'b0001;
                    end
                    2'b01 : begin
                        be_rd = {{24{r_d[15]}}, r_d[15:8]};
                        be_wd = {{16'b0}, w_d[7:0], {8'b0}};
                        byte_enable = 4'b0010;
                    end
                    2'b10 : begin
                        be_rd = {{24{r_d[23]}}, r_d[23:16]};
                        be_wd = {{8'b0}, w_d[7:0], {16'b0}};
                        byte_enable = 4'b0100;
                    end
                    2'b11 : begin
                        be_rd = {{24{r_d[31]}}, r_d[31:24]};
                        be_wd = {w_d[7:0], {24'b0}};
                        byte_enable = 4'b1000;
                    end
                    default : begin
                        be_rd = 32'h0;
                        be_wd = 32'h0;
                        byte_enable = 4'b0000;
                    end
                endcase
            end

            3'b001 : begin // signed half-word
                case (addr_last2)
                    2'b00 : begin
                        be_rd = {{16{r_d[15]}}, r_d[15:0]};
                        be_wd = {{16'b0}, w_d[15:0]};
                        byte_enable = 4'b0011;
                    end
                    2'b10 : begin
                        be_rd = {{16{r_d[31]}}, r_d[31:16]};
                        be_wd = {w_d[15:0], {16'b0}};
                        byte_enable = 4'b1100;
                    end
                    default : begin
                        be_rd = r_d;
                        be_wd = w_d;
                        byte_enable = 4'b0000;
                    end
                endcase
            end

            3'b010 : begin // signed word
                case (addr_last2)
                    2'b00 : begin
                        be_rd = r_d;
                        be_wd = w_d;
                        byte_enable = 4'b1111;
                    end
                    default : begin
                        be_rd = r_d;
                        be_wd = w_d;
                        byte_enable = 4'b0000;
                    end
                endcase
            end

            3'b100 : begin // unsigned byte
                case (addr_last2)
                    2'b00 : begin
                        be_rd = {{24'b0}, r_d[7:0]};
                        be_wd = {{24'b0}, w_d[7:0]};
                        byte_enable = 4'b0001;
                    end
                    2'b01 : begin
                        be_rd = {{24'b0}, r_d[15:8]};
                        be_wd = {{16'b0}, w_d[7:0], {8'b0}};
                        byte_enable = 4'b0010;
                    end
                    2'b10 : begin
                        be_rd = {{24'b0}, r_d[23:16]};
                        be_wd = {{8'b0}, w_d[7:0], {16'b0}};
                        byte_enable = 4'b0100;
                    end
                    2'b11 : begin
                        be_rd = {{24'b0}, r_d[31:24]};
                        be_wd = {w_d[7:0], {24'b0}};
                        byte_enable = 4'b1000;
                    end
                    default : begin
                        be_rd = r_d;
                        be_wd = w_d;
                        byte_enable = 4'b0000;
                    end
                endcase
            end

            3'b101 : begin // unsigned half-word
                case (addr_last2)
                    2'b00 : begin
                        be_rd = {{16'b0}, r_d[15:0]};
                        be_wd = {{16'b0}, w_d[15:0]};
                        byte_enable = 4'b0011;
                    end
                    2'b10 : begin
                        be_rd = {{16'b0}, r_d[31:16]};
                        be_wd = {w_d[31:16], {16'b0}};
                        byte_enable = 4'b1100;
                    end
                    default : begin
                        be_rd = 32'h0;
                        be_wd = 32'h0;
                        byte_enable = 4'b0000;
                    end
                endcase
            end

            3'b110 : begin // unsigned word
                case (addr_last2)    
                    2'b00 : begin
                        be_rd = r_d;
                        be_wd = w_d;
                        byte_enable = 4'b1111;
                    end
                    default : begin
                        be_rd = r_d;
                        be_wd = w_d;
                        byte_enable = 4'b0000;
                    end
                endcase
            end

            default : begin
                be_rd = 32'h0;
                be_wd = 32'h0;
                byte_enable = 4'b0000;
            end
        endcase
    end
endmodule
