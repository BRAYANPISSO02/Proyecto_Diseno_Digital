`timescale 1ns/1ps

module tb_top_pwm_alt;

    // Parámetros iguales al DUT
    localparam AW = 8;
    localparam DW = 32;
    localparam WIDTH_PERIOD = 16;
    localparam WIDTH_DUTY   = 16;

    reg clk_i;
    reg rst_ni;
    reg [AW-1:0] addr_i;
    reg [DW-1:0] wr_data_i;
    wire [DW-1:0] rd_data_o;
    reg wr_en_i;
    reg rd_en_i;
    wire pwm_out_o;

    // Instancia del DUT (Device Under Test)
    top_pwm_alt dut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .addr_i(addr_i),
        .wr_data_i(wr_data_i),
        .rd_data_o(rd_data_o),
        .wr_en_i(wr_en_i),
        .rd_en_i(rd_en_i),
        .pwm_out_o(pwm_out_o)
    );

    // Reloj 100MHz (10ns ciclo)
    always #5 clk_i = ~clk_i;

    initial begin
        clk_i = 0;
        rst_ni = 0;
        addr_i = 0;
        wr_data_i = 0;
        wr_en_i = 0;
        rd_en_i = 0;

        // Reset
        #30;
        rst_ni = 1;

        // Escribe periodo = 1000, duty = 250 (addr 0)
        @(negedge clk_i);
        addr_i = 8'h00;
        wr_data_i = {16'd1000, 16'd250}; // [31:16] periodo, [15:0] duty
        wr_en_i = 1;
        @(negedge clk_i);
        wr_en_i = 0;

        // Espera para observar la señal PWM
        #5000;

        // Cambiar duty a 750
        @(negedge clk_i);
        addr_i = 8'h00;
        wr_data_i = {16'd1000, 16'd750};
        wr_en_i = 1;
        @(negedge clk_i);
        wr_en_i = 0;

        #3000;

        // Probar duty > periodo (flag de error)
        @(negedge clk_i);
        addr_i = 8'h00;
        wr_data_i = {16'd400, 16'd700};
        wr_en_i = 1;
        @(negedge clk_i);
        wr_en_i = 0;

        // Lectura del registro status (addr 0x04)
        @(negedge clk_i);
        addr_i = 8'h04;
        rd_en_i = 1;
        @(negedge clk_i);
        rd_en_i = 0;

        #2000;
        $finish;
    end

    initial begin
        $dumpfile("tb/tb_top_pwm_alt.vcd");
        $dumpvars(0, tb_top_pwm_alt);
        $display("time\tpwm_out_o\trd_data_o");
        $monitor("%g\t%b\t%h", $time, pwm_out_o, rd_data_o);
    end

endmodule
