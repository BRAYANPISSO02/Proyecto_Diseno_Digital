`timescale 1ns/1ps

module tb_reg_iface;

    localparam AW = 8;
    localparam DW = 32;

    reg clk_i;
    reg rst_ni;
    reg [AW-1:0] addr_i;
    reg [DW-1:0] wr_data_i;
    wire [DW-1:0] rd_data_o;
    reg wr_en_i;
    reg rd_en_i;
    wire [DW-1:0] ctrl_o;
    reg  [DW-1:0] status_in_i;
    wire [DW-1:0] status_o;

    // Instancia del DUT
    reg_iface dut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .addr_i(addr_i),
        .wr_data_i(wr_data_i),
        .rd_data_o(rd_data_o),
        .wr_en_i(wr_en_i),
        .rd_en_i(rd_en_i),
        .ctrl_o(ctrl_o),
        .status_in_i(status_in_i),
        .status_o(status_o)
    );

    // Generador de reloj
    always #5 clk_i = ~clk_i;

    initial begin
        clk_i = 0;
        rst_ni = 0;
        addr_i = 0;
        wr_data_i = 0;
        wr_en_i = 0;
        rd_en_i = 0;
        status_in_i = 0;

        // Reset
        #10;
        rst_ni = 1;

        // Escribe en ctrl (addr = 0)
        @(negedge clk_i);
        addr_i = 8'h00;
        wr_data_i = 32'h000000FF;
        wr_en_i = 1;
        @(negedge clk_i);
        wr_en_i = 0;

        // Lee ctrl
        @(negedge clk_i);
        rd_en_i = 1;
        addr_i = 8'h00;
        @(negedge clk_i);
        rd_en_i = 0;

        // Actualiza status
        @(negedge clk_i);
        status_in_i = 32'hA5A5A5A5;

        // Lee status
        @(negedge clk_i);
        rd_en_i = 1;
        addr_i = 8'h04;
        @(negedge clk_i);
        rd_en_i = 0;

        // Reset de nuevo
        #10;
        rst_ni = 0;
        @(negedge clk_i);
        rst_ni = 1;

        // Lee ctrl
        @(negedge clk_i);
        rd_en_i = 1;
        addr_i = 8'h00;
        @(negedge clk_i);
        rd_en_i = 0;

        // Lee status
        @(negedge clk_i);
        rd_en_i = 1;
        addr_i = 8'h04;
        @(negedge clk_i);
        rd_en_i = 0;

        #20;
        $finish;
    end

    // Dump de señales
    initial begin
        $dumpfile("tb/tb_reg_iface.vcd");
        $dumpvars(0, tb_reg_iface);
        $display("time\tctrl_o\trd_data_o\tstatus_o");
        $monitor("%g\t%h\t%h\t%h", $time, ctrl_o, rd_data_o, status_o);
    end

endmodule
