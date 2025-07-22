`timescale 1ns/1ps

module tb_top_pwm;

    // Parámetros iguales a los del módulo
    localparam ADDR_WIDTH   = 8;
    localparam DATA_WIDTH   = 32;
    localparam WIDTH_PERIOD = 16;
    localparam WIDTH_DUTY   = 16;

    reg clk;
    reg reset_n;
    reg [ADDR_WIDTH-1:0] addr;
    reg [DATA_WIDTH-1:0] wdata;
    wire [DATA_WIDTH-1:0] rdata;
    reg wen;
    reg ren;
    wire pwm_out;

    // Instanciación DUT (Device Under Test)
    top_pwm dut (
        .clk(clk),
        .reset_n(reset_n),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata),
        .wen(wen),
        .ren(ren),
        .pwm_out(pwm_out)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        // Inicialización
        clk = 0;
        reset_n = 0;
        addr = 0;
        wdata = 0;
        wen = 0;
        ren = 0;

        // Reset
        #30;
        reset_n = 1;

        // Escribe periodo=1000 y duty=250 en ctrl_reg (ejemplo: addr 0)
        @(negedge clk);
        addr = 8'h00;
        wdata = {16'd1000, 16'd250}; // period[31:16], duty[15:0]
        wen = 1;
        @(negedge clk);
        wen = 0;

        // Espera algunos ciclos para ver PWM
        #5000;

        // Cambia duty a 750 (mantiene periodo)
        @(negedge clk);
        addr = 8'h00;
        wdata = {16'd1000, 16'd750};
        wen = 1;
        @(negedge clk);
        wen = 0;

        #3000;

        // Prueba duty > periodo (debería encender flag de error)
        @(negedge clk);
        addr = 8'h00;
        wdata = {16'd400, 16'd700}; // duty > periodo
        wen = 1;
        @(negedge clk);
        wen = 0;

        // Espera y termina
        #2000;
        $finish;
    end

    // Monitoreo
    initial begin
        $dumpfile("tb_top_pwm.vcd");
        $dumpvars(0, tb_top_pwm);
        $display("time\tpwm_out\trdata");
        $monitor("%g\t%b\t%h", $time, pwm_out, rdata);
    end

endmodule
