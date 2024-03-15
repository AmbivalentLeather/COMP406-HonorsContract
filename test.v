module control_unit( 
/*    input clk,
    input rst
    */

);
    reg [7:0] registers [0:3];
    reg [15:0] PC;
    reg [63:0] count;
    reg [7:0] instruction, Rs, Rd, imm, opcode, temp;

    reg [15:0] memory [0:255];

    reg [1:0] clk;
    initial begin
        forever begin
            clk = 0;
            #10 clk = ~clk;
        end
    end

    // For testing purposes only
    initial begin
        memory[0] = 'hff;
        memory[1] = 'hfe;
        memory[2] = 'h23;
        memory[2] = 'h15;
        memory[3] = 'hc8;
        memory[4] = 'hcb;
        memory[5] = 'hcd;
        memory[6] = 'hcd;
        memory[7] = 'h49;
        memory[8] = 'h5f;
        memory[9] = 'h74;
        memory[10] = 'hcc;
        memory[11] = 'hcd;
        memory[12] = 'h1b;
        memory[13] = 'hcc;
        memory[14] = 'hde;
        memory[15] = 'h5f;
        memory[16] = 'hff;
        memory[17] = 'hff;
        memory[18] = 'h37;
        memory[19] = 'h01;
    end

    always @(clk) begin
        count <= count + 1'b1;
        if (count % 'd100000000 == 0) begin
            PC <= PC + 1'b1;
        end
        
        /*
        if (rst)
            count <= 'b0;
        */
    end

    always @(PC) begin: fetch_execute
        instruction <= memory[PC];
        Rs <= (instruction & 8'b00000011);
        Rd <= (instruction & 8'b00001100);
        temp <= (instruction & 8'b00110011);
        imm <= ((temp >> 2) | temp) & 8'b00001111;
        opcode <= (instruction & 8'b11110000) >> 4;

        case (opcode)
            4'b0111: registers[Rd] <= registers[Rd] + registers[Rs];    // ADD
            4'b0001: registers[Rd] <= registers[Rd] - registers[Rs];    // SUB
            4'b0010: registers[Rd] <= memory[registers[Rs]];    // LOAD
            4'b0011: memory[registers[Rs]] <= registers[Rd];    // STORE
            4'b0100: begin 
                if (Rs == 0 && registers[Rd] == 0)
                    PC <= PC + 1;
                if (Rs == 'b01 && registers[Rd] != 0)
                    PC <= PC + 1;
            end // SKIPZ SKIPNZ
            4'b0101: begin 
                temp <= registers[Rs];
                registers[Rd] <= PC + 1;
                PC = temp + 1;
            end // JALR
            4'b1100: begin // The case statement is wrong here, opcode is never equal to 1100
                temp <= registers[Rd];
                temp <= (temp << 4) & 8'b11110000;
                temp <= temp | imm;
                registers[Rd] <= temp;
            end // SLI // How does SLI work in a case statement?
            4'b0110: registers[Rd] <= ~(registers[Rs] & registers[Rd]); // NAND
            4'b1000: begin
                case (Rs)
                0:  registers[Rd] <= registers[Rd] + 1;
                1:  registers[Rd] <= registers[Rd] - 1;
                // 2: OUT
                // 3: IN
                default: ;
                endcase
            end
            4'b0000: begin 
                if (Rs == 1)
                    $finish;
                    //disable fetch_execute;
            end // HALT, NOP
            default: ;
        endcase
        $display("A: %d, B: %d, C: %d, D: %d", registers[0], registers[1], registers[2], registers[3]);
    end

endmodule
