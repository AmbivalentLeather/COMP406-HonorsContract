module control_unit( 
/*    input clk,
    input rst
    */

);
    reg [7:0] registers [3:0];
    reg [7:0] PC;
    reg [1:0] loop_flag;
    reg [7:0] instruction, Rs, Rd, imm, opcode, temp;

    reg [15:0] memory [0:255];

    reg [1:0] clk;
    // This block doesn't seem to do anything
    initial begin
        forever begin
            clk = 0;
            #5 clk = ~clk;
        end
    end

    always @(posedge clk) begin
        PC <= PC + 1;
        if (PC == 0) begin
            loop_flag <= loop_flag + 1;
        end
    end
    // For testing purposes only
    initial begin
        // If we don't do this the registers 
        // need to be set to 0 in the code
        registers[0] = 0;
        registers[1] = 0;
        registers[2] = 0;
        registers[3] = 0;
        
        /* Store/load test
        memory[0] = 'hc0;
        memory[1] = 'hd1;
        memory[2] = 'hf7;
        memory[3] = 'hf6;
        memory[4] = 'h31;
        memory[5] = 'h29;
        memory[6] = 'h01;
        */

        /* Multiply 2 * 3
        */
        memory[0] = 'hff;
        memory[1] = 'hfe;
        memory[2] = 'h23;
        memory[3] = 'h15;
        memory[4] = 'hc8;
        memory[5] = 'hcb;
        memory[6] = 'hcd;
        memory[7] = 'hcd;
        memory[8] = 'h49;
        memory[9] = 'h5f;
        memory[10] = 'h74;
        memory[11] = 'hcc;
        memory[12] = 'hcd;
        memory[13] = 'h1b;
        memory[14] = 'hcc;
        memory[15] = 'hde;
        memory[16] = 'h5f;
        memory[17] = 'hff;
        memory[18] = 'hff;
        memory[19] = 'h37;
        memory[20] = 'h01;

        memory['hfe] = 'd2;

    for (PC = 0; PC < 100; PC = PC + 'd1) begin
        instruction = memory[PC];
        Rs = (instruction & 8'b00000011);
        Rd = (instruction & 8'b00001100) >> 2;
        temp = (instruction & 8'b00110011);
        imm = ((temp >> 2) | temp) & 8'b00001111;
        opcode = (instruction & 8'b11110000) >> 4;

        if ((opcode & 'b1100) == 'b1100) begin
                temp = registers[Rd];
                temp = (temp << 4) & 8'b11110000;
                temp = temp | imm;
                registers[Rd] = temp;
        end // Manually pick out SLI

        case (opcode)
            4'b0111: registers[Rd] = registers[Rd] + registers[Rs];
            4'b0001: registers[Rd] = registers[Rd] - registers[Rs];    // SUB
            4'b0010: begin
                temp = registers[Rs];
                registers[Rd] = memory[registers[Rs]];    // LOAD
            end // VERIFIED WORKING
            4'b0011: begin
                memory[registers[Rs]] = registers[Rd];    // STORE
            end // VERIFIED WORKING
            4'b0100: begin 
                if (Rs == 0 && registers[Rd] == 0) begin
                    PC = PC + 1;
                end
                if (Rs == 1 && registers[Rd] != 0) begin    // SKIPNZ: NOT WORKING
                    PC = PC + 1;
                end
            end // SKIPZ SKIPNZ
            4'b0101: begin 
                temp = registers[Rs];
                registers[Rd] = PC + 1;
                PC = temp + 1;
            end // JALR
            4'b0110: registers[Rd] = ~(registers[Rs] & registers[Rd]); // NAND
            4'b1000: begin
                case (Rs)
                0:  registers[Rd] = registers[Rd] + 1;
                1:  registers[Rd] = registers[Rd] - 1;
                // 2: OUT
                // 3: IN
                default: ;
                endcase
            end
            4'b0000: begin 
                if (Rs == 1) begin
                    $display("instruction: %b, A: %h, B: %h, C: %h, D: %h", instruction, registers[0], registers[1], registers[2], registers[3]);
                    $finish;
                    //$display("Final val: %d", registers[01]);
                end
                    //disable fetch_execute;
            end // HALT, NOP
            default: ;
        endcase
        $display("instruction: %b, A: %h, B: %h, C: %h, D: %h", instruction, registers[0], registers[1], registers[2], registers[3]);
    end

    end

endmodule
