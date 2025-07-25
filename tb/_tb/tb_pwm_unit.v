`timescale 1ns/1ps

module tb_pwm_unit;

    // Parámetros igual que el módulo
    localparam CNT_WIDTH   = 16;
    localparam DUTY_WIDTH  = 16;

    reg clk_i;
    reg rst_ni;
    reg [CNT_WIDTH-1:0] cfg_period;
    reg [DUTY_WIDTH-1:0] cfg_duty;
    wire pwm_o;

    // Instancia del DUT
    pwm_unit #(
        .CNT_WIDTH(CNT_WIDTH),
        .DUTY_WIDTH(DUTY_WIDTH)
    ) dut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .cfg_period(cfg_period),
        .cfg_duty(cfg_duty),
        .pwm_o(pwm_o)
    );

    // Generador de reloj
    always #5 clk_i = ~clk_i;

    initial begin
        clk_i = 0;
        rst_ni = 0;
        cfg_period = 10;
        cfg_duty = 4;

        // Aplica reset
        #12;
        rst_ni = 1;

        // Espera para ver la forma de onda PWM con duty=4/10
        #120;

        // Cambia duty a 7 (PWM ON 7/10 del tiempo)
        cfg_duty = 7;
        #100;

        // Cambia el periodo a 16, duty a 8
        cfg_period = 16;
        cfg_duty = 8;
        #160;

        // Prueba duty=0 y duty=period
        cfg_duty = 0; // PWM siempre en 0
        #20;
        cfg_duty = 16; // PWM siempre en 1 (period = 16)
        #20;

        $finish;
    end

    // Guardar forma de onda y monitoreo básico
    initial begin
        $dumpfile("tb/tb_pwm_unit.vcd");
        $dumpvars(0, tb_pwm_unit);
        $display("time\tpwm_o");
        $monitor("%g\t%b", $time, pwm_o);
    end

endmodule
