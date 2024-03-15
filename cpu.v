`timescale 1ns / 1ns
module control_unit( 
/*    input clk,
    input rst
    */

);
    reg [15:0] memory [0:255];
    reg [7:0] registers [3:0];
    reg [7:0] instruction, Rs, Rd, imm, opcode, temp;


    reg clk;
    reg [7:0] PC;
    reg [1:0] loop_flag;


    // For testing purposes only
    initial begin
        // If we don't do this the registers
        // need to be set to 0 in the code
        registers[0] = 0;
        registers[1] = 0;
        registers[2] = 0;
        registers[3] = 0;

        // Multiply 2 * 3
        memory[0] = 16'hff;
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
    end

    initial begin
        clk = 1'b0;
        PC = 8'd0;
        forever 
            #5 clk = ~clk;
    end

    always @(posedge clk) begin

        instruction = memory[PC];
        Rs = (instruction & 8'b00000011);
        Rd = (instruction & 8'b00001100) >> 2;
        //temp <= (instruction & 8'b00110011);
        imm = (((instruction & 8'b00110011) >> 2) | (instruction & 8'b00110011)) & 8'b00001111;
        opcode = (instruction & 8'b11110000) >> 4;

        if ((opcode & 4'b1100) == 4'b1100) begin
                registers[Rd] = ((registers[Rd] << 4) & 8'b11110000) | imm;
                //$display("Rd: %h, Imm: %d", Rd, imm);
        end // Manually pick out SLI
        // case (opcode & 4'b1100)
        //     4'b1100: begin
        //         temp <= registers[Rd];
        //         temp <= (temp << 4) & 8'b11110000;
        //         temp <= temp | imm;
        //         registers[Rd] <= temp;
        //         end
        // endcase

        case (opcode)
            4'b0111: registers[Rd] = registers[Rd] + registers[Rs];
            4'b0001: registers[Rd] = registers[Rd] - registers[Rs];    // SUB
            4'b0010: registers[Rd] <= memory[registers[Rs]];    // LOAD
            4'b0011: memory[registers[Rs]] <= registers[Rd];    // STORE
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
            4'b0110: registers[Rd] <= ~(registers[Rs] & registers[Rd]); // NAND
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
                end
            end // HALT, NOP
            default: ;
        endcase
        $display("pc: %h, mem: %h, instruction: %b, A: %h, B: %h, C: %h, D: %h", PC, memory[PC], instruction, registers[0], registers[1], registers[2], registers[3]);
        PC = PC + 8'd1;
        // if (PC == 'd11) begin
        //      $finish;
        // end
    end

endmodule
