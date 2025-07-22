`timescale 1ns/1ps

module tb_reg_if;

    localparam ADDR_WIDTH = 8;
    localparam DATA_WIDTH = 32;

    reg clk;
    reg reset_n;
    reg [ADDR_WIDTH-1:0] addr;
    reg [DATA_WIDTH-1:0] wdata;
    wire [DATA_WIDTH-1:0] rdata;
    reg wen;
    reg ren;
    wire [DATA_WIDTH-1:0] ctrl;
    reg  [DATA_WIDTH-1:0] status_in;
    wire [DATA_WIDTH-1:0] status;

    // Instanciación del DUT
    reg_if dut (
        .clk(clk),
        .reset_n(reset_n),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata),
        .wen(wen),
        .ren(ren),
        .ctrl(ctrl),
        .status_in(status_in),
        .status(status)
    );

    // Generador de reloj
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset_n = 0;
        addr = 0;
        wdata = 0;
        wen = 0;
        ren = 0;
        status_in = 0;

        // Reset global
        #10;
        reset_n = 1;

        // Escribir en ctrl_reg (ADDR_CTRL = 0)
        @(negedge clk);
        addr = 8'h00;
        wdata = 32'h0000_00FF; // ejemplo
        wen = 1;
        @(negedge clk);
        wen = 0;

        // Leer ctrl_reg
        @(negedge clk);
        ren = 1;
        addr = 8'h00;
        @(negedge clk);
        ren = 0;

        // Actualizar status_in y simular status externo (ADDR_STATUS = 4)
        @(negedge clk);
        status_in = 32'hA5A5_A5A5;

        // Leer status_reg
        @(negedge clk);
        ren = 1;
        addr = 8'h04;
        @(negedge clk);
        ren = 0;

        // Reset
        #10;
        reset_n = 0;
        @(negedge clk);
        reset_n = 1;

        // Leer tras reset
        @(negedge clk);
        ren = 1;
        addr = 8'h00;
        @(negedge clk);
        ren = 0;

        @(negedge clk);
        ren = 1;
        addr = 8'h04;
        @(negedge clk);
        ren = 0;

        #20;
        $finish;
    end

    // Observación de señales
    initial begin
        $dumpfile("tb_reg_if.vcd");
        $dumpvars(0, tb_reg_if);
        $display("time\tctrl_reg\trdata\tstatus");
        $monitor("%g\t%h\t%h\t%h", $time, ctrl, rdata, status);
    end

endmodule
