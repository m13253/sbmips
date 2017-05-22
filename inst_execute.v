`timescale 1ns / 1ps
`default_nettype none

module inst_execute(
    input wire clk,
    input wire rst,

    input wire [31:2] pc_in,
    input wire [31:0] inst,
    input wire [5:0] opcode,
    input wire [4:0] rs,
    input wire [4:0] rt,
    input wire [4:0] rd,
    input wire [4:0] shamt,
    input wire [5:0] funct,
    input wire [25:0] immed,

    output wire [4:0] reg_addr_a,
    input wire [31:0] reg_dout_a,
    output wire [4:0] reg_addr_b,
    input wire [31:0] reg_dout_b,

    output reg [31:2] mem_addr,
    output reg [31:0] mem_din,
    output reg mem_en,
    output reg mem_we,

    input wire [4:0] mem_rd,
    input wire [31:0] mem_rd_val,

    output reg [31:2] pc_out,
    output reg [31:0] inst_out,
    output reg jump,
    output reg [31:2] jump_pc,
    output reg load,
    output reg store,
    output reg [4:0] rd_out,
    output reg [31:0] rd_val
    );

initial begin
    pc_out = 30'hzzzzzzzz; inst_out = 32'hzzzzzzzz;
    mem_addr = 30'hzzzzzzzz; mem_din = 32'hzzzzzzzz;
    mem_en = 0; mem_we = 0;
    jump = 0; jump_pc = 0;
    load = 0; store = 0;
    rd_out = 0; rd_val = 0;
end

reg [4:0] last_rd = 0;
reg [31:0] last_rd_val = 0;

assign reg_addr_a = rs;
assign reg_addr_b = opcode == 6'h00 ? rt : rd;
wire [31:0] reg_data_a =
    reg_addr_a == last_rd ? last_rd_val :
    reg_addr_a == mem_rd ? mem_rd_val : reg_dout_a;
wire [31:0] reg_data_b =
    reg_addr_b == last_rd ? last_rd_val :
    reg_addr_b == mem_rd ? mem_rd_val : reg_dout_b;

reg [31:0] alu_a;
reg [31:0] alu_b;
reg [4:0] alu_shamt;
reg [5:0] alu_op;
wire [31:0] alu_out;

alu alu(
    .a(alu_a), .b(alu_b), .shamt(alu_shamt),
    .alu_op(alu_op), .out(alu_out)
    );

reg [1:0] flush_counter = 0;

always @(*) begin
    if(flush_counter == 1) begin
        alu_a = 0;
        alu_b = 0;
        alu_shamt = 0;
        alu_op = 0;
        mem_addr = 32'hzzzzzzzz; mem_din = 32'hzzzzzzzz;
        mem_en = 0; mem_we = 0;
    end else if(opcode == 6'h00) begin
        alu_a = reg_data_a;
        alu_b = reg_data_b;
        alu_shamt = shamt;
        alu_op = funct;
        mem_addr = 32'hzzzzzzzz; mem_din = 32'hzzzzzzzz;
        mem_en = 0; mem_we = 0;
    end else if(opcode == 6'h02 || opcode == 6'h03) begin
        alu_a = pc_in & 32'hf0000000;
        alu_b = {4'h0, immed, 2'h0};
        alu_shamt = 0;
        alu_op = 6'h25; // or
        mem_addr = 32'hzzzzzzzz; mem_din = 32'hzzzzzzzz;
        mem_en = 0; mem_we = 0;
    end else
        case(opcode)
            6'h04: begin // beq
                alu_a = {pc_in, 2'h0};
                alu_b = $signed({immed, 2'h0});
                alu_shamt = 0;
                alu_op = 6'h20; // add
                mem_addr = 32'hzzzzzzzz; mem_din = 32'hzzzzzzzz;
                mem_en = 0; mem_we = 0;
            end
            6'h05: begin // bne
                alu_a = {pc_in, 2'h0};
                alu_b = $signed({immed, 2'h0});
                alu_shamt = 0;
                alu_op = 6'h20; // add
                mem_addr = 32'hzzzzzzzz; mem_din = 32'hzzzzzzzz;
                mem_en = 0; mem_we = 0;
            end
            6'h08: begin // addi
                alu_a = reg_data_a;
                alu_b = $signed(immed);
                alu_shamt = 0;
                alu_op = 6'h20; // add
                mem_addr = 32'hzzzzzzzz; mem_din = 32'hzzzzzzzz;
                mem_en = 0; mem_we = 0;
            end
            6'h09: begin // addiu
                alu_a = reg_data_a;
                alu_b = $unsigned(immed[15:0]);
                alu_shamt = 0;
                alu_op = 6'h21; // add
                mem_addr = 32'hzzzzzzzz; mem_din = 32'hzzzzzzzz;
                mem_en = 0; mem_we = 0;
            end
            6'h0a: begin // slti
                alu_a = reg_data_a;
                alu_b = $signed(immed);
                alu_shamt = 0;
                alu_op = 6'h2a; // slt
                mem_addr = 32'hzzzzzzzz; mem_din = 32'hzzzzzzzz;
                mem_en = 0; mem_we = 0;
            end
            6'h0b: begin // sltiu
                alu_a = reg_data_a;
                alu_b = $unsigned(immed[15:0]);
                alu_shamt = 0;
                alu_op = 6'h2b; // sltu
                mem_addr = 32'hzzzzzzzz; mem_din = 32'hzzzzzzzz;
                mem_en = 0; mem_we = 0;
            end
            6'h0c: begin // andi
                alu_a = reg_data_a;
                alu_b = $unsigned(immed[15:0]);
                alu_shamt = 0;
                alu_op = 6'h24; // and
                mem_addr = 32'hzzzzzzzz; mem_din = 32'hzzzzzzzz;
                mem_en = 0; mem_we = 0;
            end
            6'h0d: begin // ori
                alu_a = reg_data_a;
                alu_b = $unsigned(immed[15:0]);
                alu_shamt = 0;
                alu_op = 6'h25; // or
                mem_addr = 32'hzzzzzzzz; mem_din = 32'hzzzzzzzz;
                mem_en = 0; mem_we = 0;
            end
            6'h0e: begin // xori
                alu_a = reg_data_a;
                alu_b = $unsigned(immed[15:0]);
                alu_shamt = 0;
                alu_op = 6'h26; // xor
                mem_addr = 32'hzzzzzzzz; mem_din = 32'hzzzzzzzz;
                mem_en = 0; mem_we = 0;
            end
            6'h0f: begin // lui
                alu_a = 0;
                alu_b = {immed[15:0], 16'h0000};
                alu_shamt = 0;
                alu_op = 6'h25; // or
                mem_addr = 32'hzzzzzzzz; mem_din = 32'hzzzzzzzz;
                mem_en = 0; mem_we = 0;
            end
            6'h23: begin // lw
                alu_a = reg_data_a;
                alu_b = $signed(immed);
                alu_shamt = 0;
                alu_op = 6'h21; // addu
                mem_addr = alu_out[31:2];
                mem_din = 32'hzzzzzzzz;
                mem_en = 1; mem_we = 0;
            end
            6'h2b: begin // sw
                alu_a = reg_data_a;
                alu_b = $signed(immed);
                alu_shamt = 0;
                alu_op = 6'h21; // addu
                mem_addr = alu_out[31:2];
                mem_din = reg_data_b;
                mem_en = 1; mem_we = 1;
            end
            default: begin
                alu_a = 32'hzzzzzzzz;
                alu_b = 32'hzzzzzzzz;
                alu_shamt = 5'hxx;
                alu_op = 6'hxx;
                mem_addr = 32'hzzzzzzzz; mem_din = 32'hzzzzzzzz;
                mem_en = 0; mem_we = 0;
            end
        endcase
end

always @(posedge clk, posedge rst) begin
    if(rst) begin
        pc_out = 30'hzzzzzzzz; inst_out = 32'hzzzzzzzz;
        jump = 0; jump_pc = 0;
        load = 0; store = 0;
        rd_out = 0; rd_val = 0;
        last_rd = 0; last_rd_val = 0;
        flush_counter = 0;
    end else if(flush_counter == 1) begin
        pc_out = pc_in; inst_out = 32'h00000000;
        jump = 0; jump_pc = 0;
        load = 0; store = 0;
        rd_out = 0; rd_val = 0;
        last_rd = 0; last_rd_val = 0;
        flush_counter = 0;
    end else begin
        flush_counter = flush_counter == 0 ? 0 : flush_counter - 1;
        if(opcode == 6'h02 || opcode == 6'h03) begin
            pc_out = pc_in; inst_out = inst;
            jump = 1; jump_pc = alu_out[31:2];
            load = 0; store = 0;
            if(opcode == 6'h03) begin // jal
                rd_out = 5'h1f; rd_val = (pc_in << 2) + 8;
            end else begin // j
                rd_out = 0; rd_val = 0;
            end
            last_rd = rd_out; last_rd_val = rd_out != 0 ? rd_val : 0;
            flush_counter = 2;
        end else if(opcode == 6'h04 || opcode == 6'h05) begin
            pc_out = pc_in; inst_out = inst;
            if(opcode == 6'h04) // beq
                jump = reg_data_a == reg_data_b;
            else // bne
                jump = reg_data_a != reg_data_b;
            jump_pc = alu_out[31:2] + 1;
            load = 0; store = 0;
            rd_out = 0; rd_val = 0;
            last_rd = 0; last_rd_val = 0;
            if(jump)
                flush_counter = 2;
        end else if(opcode == 6'h23) begin // lw
            pc_out = pc_in; inst_out = inst;
            jump = 0; jump_pc = 0;
            load = 1; store = 0;
            rd_out = rd; rd_val = reg_data_b;
            last_rd = 0; last_rd_val = 0;
        end else if(opcode == 6'h2b) begin // sw
            pc_out = pc_in; inst_out = inst;
            jump = 0; jump_pc = 0;
            load = 0; store = 1;
            rd_out = rd; rd_val = reg_data_b;
            last_rd = 0; last_rd_val = 0;
        end else if(opcode == 6'h00 && funct == 6'h08) begin // jr
            pc_out = pc_in; inst_out = inst;
            jump = 1; jump_pc = reg_data_a[31:2];
            load = 0; store = 0;
            rd_out = 0; rd_val = 0;
            last_rd = 0; last_rd_val = 0;
            flush_counter = 2;
        end else if(opcode == 6'h00 && funct == 6'h09) begin // jalr
            pc_out = pc_in; inst_out = inst;
            jump = 1; jump_pc = reg_data_a[31:2];
            load = 0; store = 0;
            rd_out = 5'h1f; rd_val = (pc_in << 2) + 8;
            last_rd = rd_out; last_rd_val = rd_out != 0 ? rd_val : 0;
            flush_counter = 2;
        end else begin
            pc_out = pc_in; inst_out = inst;
            jump = 0; jump_pc = 0;
            load = 0; store = 0;
            rd_out = rd; rd_val = alu_out;
            last_rd = rd_out; last_rd_val = rd_out != 0 ? rd_val : 0;
        end
    end
end

endmodule
